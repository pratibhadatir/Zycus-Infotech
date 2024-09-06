global class VLSF_ExotelEmailIntegration implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        // Debugging email details
        system.debug('From email address : '+email.fromAddress);
        system.debug('htmlBody : '+email.htmlBody);
        system.debug('subject : '+email.subject);
        system.debug('toAddresses : '+email.toAddresses);
        system.debug('plainTextBody : '+email.plainTextBody);
        system.debug('toAddresses : '+email.toAddresses);
        

        
        try {
            String emailSubject = email.subject;
            String emailBody = (email.plainTextBody != null) ? email.plainTextBody : email.htmlBody.stripHtmlTags();
            String sipValue = extractSipValue(emailBody);
            System.debug('SIP: ' + sipValue);
            
            // Fetching Region, Team, SubTeam based on SIP value from metadata
            Map<String, String> metadataValues = VLSF_SIPAndEmailMetadataHelper.getMetadataValuesBySip(sipValue);
            System.debug('Metadata Values: ' + metadataValues);
            
            // Creating a new Case record
            Case newCase = new Case(
                Subject = emailSubject,
                Description = emailBody,
                //OwnerId = (caseOwner != null) ? caseOwner.Id : null,
                Origin='Call',
                VLSF_Incident_Type__c='Case'
            );
            
            if (metadataValues!=null ) {
                // Assign metadata values to newCase
                newCase.VLSF_Region__c = metadataValues.get('Region');
                newCase.VLSF_Team__c = metadataValues.get('Team');
                newCase.VLSF_Sub_Team__c = metadataValues.get('SubTeam');
                
                
            } else {
                newCase.VLSF_Team__c = 'Tech Support';
                newCase.VLSF_Sub_Team__c = 'Tech-Support';
            }
            
            // Fetching the user based on the SIP value
            User caseOwner = VLSF_SIPAndEmailMetadataHelper.getUserBySipValue(sipValue);
            if (caseOwner != null) {
                newCase.OwnerId = caseOwner.Id;
                //system.debug('OwnerId'+newCase.OwnerId);
                
                newCase.VLSF_Assigned_To__c = caseOwner.Name; // Set VLSF_Assigned_To__c to caseOwner
            }else{
                Group techSupportQueue = getTechSupportQueue();
                // Assigning to Tech-Support Queue
                newCase.OwnerId = techSupportQueue.Id;
                newCase.VLSF_Assigned_To__c = 'Tech-Support';
            }
            
            // Fetching the Record Type Id for 'Incident'
            String incidentRecordTypeName = 'Incident'; // Replace with your Record Type Name
            Id incidentRecordTypeId = getRecordTypeId(incidentRecordTypeName);
            if (incidentRecordTypeId != null) {
                System.debug('Record Type Name' + incidentRecordTypeId);
                newCase.RecordTypeId = incidentRecordTypeId;
            } else {
                newCase.RecordTypeId = getDefaultRecordTypeId();
            }
            
            System.debug('newCase'+newCase);
            insert newCase;
            
            insertTask(newCase, email,emailBody);
            
            result.success = true;
        } catch (Exception ex) {
            result.success = false;
            result.message = 'An error occurred while processing the email: ' + ex.getMessage();
            System.debug('Error processing inbound email: ' + ex.getMessage());
            VLSF_ExceptionLog.ExceptionLog(ex);
        }return result;
    }
    @TestVisible
    // Method to extract SIP value from the email body
    private String extractSipValue(String emailBody) {
        // Sample regular expression to extract SIP value from the email body
        Pattern sipPattern = Pattern.compile('sip:(\\w+)');
        Matcher sipMatcher = sipPattern.matcher(emailBody);
        if (sipMatcher.find()) {
            return sipMatcher.group(1);
        } else {return null;
        }
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
    public static Id recordTypeId;
    @TestVisible
    // Method to fetch Record Type Id by Name
    private Id getRecordTypeId(String recordTypeName) {
        // Query to fetch Record Type Id based on Name
        List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = :recordTypeName LIMIT 1];
        if (!recordTypes.isEmpty()) {
            return recordTypes[0].Id;
        }return null;
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
        }System.debug('defaultRecordTypeId::' + defaultRecordTypeId);
        return defaultRecordTypeId;
    }
    @TestVisible
    private void insertTask(case newCase,Messaging.InboundEmail email,String emailBody){
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.status = '3'; // email was sent
        emailMessage.relatedToId = newCase.id; 
        emailMessage.fromAddress = email.fromAddress;// from address
        emailMessage.toAddress = email.toAddresses[0];
        emailMessage.Subject = email.subject;
        emailMessage.HtmlBody = emailBody;
        insert emailMessage;
    }
}