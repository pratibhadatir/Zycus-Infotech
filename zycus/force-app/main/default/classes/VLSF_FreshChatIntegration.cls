global class VLSF_FreshChatIntegration implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        try {
            // Extracting information from the inbound email
            String subject = email.subject;
            String htmlBody = email.htmlBody;
             System.debug('htmlBody: ' + htmlBody);
            String plainTextBody = htmlBody.stripHtmlTags(); // Convert HTML to plain text
            String body = plainTextBody;
            System.debug('body: ' + body);

            
            // Extracting contact email from the body
            String contactEmail = extractClientEmailAddress(body);
            
            // Fetching the Contact Id
            Id contactId = getContactIdByEmail(contactEmail);
            System.debug('Case contactId: ' + contactId);
            
            // Create a new Case object
            Case newCase = new Case();
            
            // Assigning Contact Id to Case if contact exists, otherwise, store the email in a custom field
            if (contactId != null) {
                newCase.ContactId = contactId;
            } else {
                newCase.VLSF_From_Email_Address__c = contactEmail;
                newCase.SuppliedEmail = contactEmail;
            }
            
            // Mapping fields from email to Case object
            newCase.Subject = subject;
            newCase.Description = body;
            system.debug('newCase.Description : '+newCase.Description);
            newCase.Origin = 'FreshChat';
            newCase.VLSF_Incident_Type__c = 'Incident';
            
            // Fetching the Record Type Id for 'Incident'
            String incidentRecordTypeName = 'Incident'; // Replace with your Record Type Name
            Id incidentRecordTypeId = getRecordTypeId(incidentRecordTypeName);
            
            // Check if the Incident record type is found
            if (incidentRecordTypeId != null) {
                newCase.RecordTypeId = incidentRecordTypeId;
            } else {
                newCase.RecordTypeId = getDefaultRecordTypeId();
            }
            
            // Fetching Region, Team, SubTeam based on Analyst Email
            String technicalSupportAnalystEmail = extractTechnicalSupportAnalystEmail(plainTextBody);
            if (technicalSupportAnalystEmail != null) {
                Map<String, String> metadataValues = VLSF_SIPAndEmailMetadataHelper.getMetadataValuesByAnalystEmail(technicalSupportAnalystEmail);
                if (metadataValues != null && !metadataValues.isEmpty()) {
                    newCase.VLSF_Region__c = metadataValues.get('Region');
                    newCase.VLSF_Team__c = metadataValues.get('Team');
                    newCase.VLSF_Sub_Team__c = metadataValues.get('SubTeam');
                }
            }
            
            // Fetching the agent's information and assigning the Case Owner
            if (technicalSupportAnalystEmail != null) {
                User agentUser = getAgentUserByEmail(technicalSupportAnalystEmail);
                if (agentUser != null) {
                    newCase.OwnerId = agentUser.Id;
                    newCase.VLSF_Assigned_To__c = agentUser.Name; 
                } else {
                    Group techSupportQueue = getTechSupportQueue();
                    newCase.OwnerId = techSupportQueue.Id;
                    newCase.VLSF_Team__c = 'Tech Support';
                    newCase.VLSF_Sub_Team__c = 'Tech-Support';
                    newCase.VLSF_Assigned_To__c = 'Tech-Support';
                }
            }
            
            // Extract Conversation Id from email body
            String conversationId = extractConversationId(body);
            if (conversationId != null) {
                // Query to check if a Case with the same FreshChat Conversation Id exists
                List<Case> existingCases = [SELECT Id FROM Case WHERE VLSF_FreshChat_Conversation_Id__c = :conversationId LIMIT 1];
                if (!existingCases.isEmpty()) {
                    // If a Case with the same Conversation Id exists, update its description
                    Case existingCase = existingCases[0];
                    existingCase.Description = body;
                    update existingCase;
                    result.success = true;
                } else {
                    // If no Case with the same Conversation Id exists, create a new Case
                    newCase.VLSF_FreshChat_Conversation_Id__c = conversationId;
                    insert newCase;
                    result.success = true;
                }
            } else {
                // If Conversation Id is null, create a new Case without checking for existing Conversation Ids
                insert newCase;
                system.debug('newCase'+newCase);
                result.success = true;
            }
            
        } catch (Exception ex) {
            result.success = false;
            result.message = 'An error occurred while processing the email: ' + ex.getMessage();
            System.debug('Error processing inbound email: ' + ex.getMessage());
            VLSF_ExceptionLog.ExceptionLog(ex, 'freshChatCreation');
        }
        
        // Handling email for sending response
       /* Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{ 'ujwala.mane@vyomlabs.com' };
            mail.setToAddresses(toAddresses);
        mail.setSubject('FreshChat');
        mail.setPlainTextBody(email.htmlBody);
        Messaging.SendEmailResult[] emailResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });*/
        
        return result;
    } 
    
    // Method to extract Technical Support Analyst name and email from email body
    @TestVisible
    public static String extractTechnicalSupportAnalystEmail(String body){
        String analystEmail = null;
        if (body != null){
            Integer startIndex = body.indexOf('-') + 1;
            Integer endIndex = body.indexOf('_', startIndex);
            if (startIndex != -1 && endIndex != -1){
                analystEmail = body.substring(startIndex, endIndex).trim();
                //analystEmail += '.invalid';
            }
        }
        System.debug('Fetching Userbefore Return' + analystEmail);
        return analystEmail;//.trim()
    }
    
    //public static User agentDetail;
   
   /* public User getAgentUserByEmail(String email){
        system.debug('EMAIL --- '+email);
        //email=email.trim();
        system.debug('EMAIL trim--- '+email);
        //email='jeston.dsouza@zycus.com.invalid';
        User userDetail = [SELECT Id, Name FROM User WHERE Email = :email LIMIT 1];
        if (userDetail != null){
            System.debug('userDetail::' + userDetail);
            return userDetail;
        }
        return null;
    }*/
     @TestVisible
    public User getAgentUserByEmail(String email){
    User userDetail = null;    
    try {
        userDetail = [SELECT Id, Name FROM User WHERE Email = :email LIMIT 1];
        
        if (userDetail != null) {
            System.debug('userDetail::' + userDetail);
            return userDetail;
        }
    } catch (QueryException e) {
        System.debug('Query failed: ' + e.getMessage());
    }return null;
}
    @TestVisible
public Group getTechSupportQueue() {
    Group techSupportQueue = null;
    try {
        techSupportQueue = [SELECT Id, Name FROM Group WHERE Name = 'Tech-Support' AND Type = 'Queue' LIMIT 1];
        
        if (techSupportQueue != null) {
            System.debug('Tech-Support Queue: ' + techSupportQueue);
            return techSupportQueue;
        }
    } catch (QueryException e) {
        System.debug('Query failed: ' + e.getMessage());
    }return null;
}

    
    // Method to extract contact email from the body
    @TestVisible
    private static String extractClientEmailAddress(String body){
        String clientEmailAddress = null;
        if (body != null){
            // Extracting Client Email Address
            integer startIndex = body.indexOf('Client Email Address:') + 'Client Email Address:'.length();
            integer endIndex = body.indexOf('_', startIndex);
            if (startIndex != -1 && endIndex != -1){
                clientEmailAddress = body.substring(startIndex, endIndex).trim();
            }
        }return clientEmailAddress;
    }
    
        // Method to extract Conversation Id from email body
@TestVisible
public static String extractConversationId(String body){
    String conversationId = null;
    if (body != null){
        Integer startIndex = body.indexOf('Conversation Id:') + 'Conversation Id:'.length();
        if (startIndex != -1 && startIndex + 37 <= body.length()){
            conversationId = body.substring(startIndex, startIndex + 37).trim();
        }
    }
    system.debug('conversationId testing: '+conversationId);
    return conversationId;
}


    
    public static Id contactRecordId;
    // Method to fetch Contact Id by email
    @TestVisible
    public Id getContactIdByEmail(String conEmail){
        // Query to fetch Contact Id based on conEmail
        List<Contact> contactList = [SELECT Id FROM Contact WHERE Email = :conEmail LIMIT 1];
        if (!contactList.isEmpty()){
            contactRecordId = contactList[0].Id;
            System.debug('contactRecordId::' + contactRecordId);
            return contactRecordId;
        }
        return null;
    }
    
    public static Id recordTypeId;
    // Method to fetch Record Type Id by Name
    @TestVisible
    public Id getRecordTypeId(String recordTypeName){
        // Query to fetch Record Type Id based on Name
        List<RecordType> recordTypeList = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = :recordTypeName LIMIT 1];
        if (!recordTypeList.isEmpty()){
            recordTypeId = recordTypeList[0].Id;
            System.debug('recordTypeId::' + recordTypeId);
            return recordTypeId;
        }
        return null;
    }
    
    public static Id defaultRecordTypeId ;
    // Method to fetch the default Record Type Id for Case
    @TestVisible
    public Id getDefaultRecordTypeId(){
        List<Schema.RecordTypeInfo> infos = Schema.SObjectType.Case.RecordTypeInfos;
        
        // Check each record type info
        for (Schema.RecordTypeInfo info : infos){
            if (info.isDefaultRecordTypeMapping()){
                defaultRecordTypeId = info.getRecordTypeId();
                System.debug('defaultRecordTypeId::' + defaultRecordTypeId);
                System.debug('Default Record Type ID: ' + defaultRecordTypeId);
                break;
            }
        }
        System.debug('defaultRecordTypeId::' + defaultRecordTypeId);
        return defaultRecordTypeId;
    }
}