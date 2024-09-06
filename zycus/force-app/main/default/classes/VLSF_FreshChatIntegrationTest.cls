@isTest
private class VLSF_FreshChatIntegrationTest {
    
    @isTest
    static void testHandleInboundEmail() {
        Contact testContact = new Contact(
            LastName = 'test contact', 
            Email = 'contact@example.com'
        );
        insert testContact;
        
        
        VLSF_FreshChatIntegration integrationInstance = new VLSF_FreshChatIntegration();
        Id contactId = integrationInstance.getContactIdByEmail('contact@example.com');
        System.debug('contactId::' + contactId);
        System.assertEquals(testContact.Id, contactId, 'Incorrect contact Id retrieval');
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Email Subject';
        String bodyEmail ='Technical Support Analyst: Shruti Pandey - shruti.pandey@zycus.com_______________/nClient Email Address:contact@example.com';
        bodyEmail +='_______________/nClient Name: Paul Flohr _______________/nTenant Name: {user.properties.tenantName} _______________/nClient Name: Paul Flohr _______________/nRegion: PROD _______________/nProduct Page: DewDrops Home_______________/n------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------/n** Chat Transcript **_______________/nPaul 17-Apr-24, 17:49 Hello ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------/nChat Conversation URL: https://zycus.freshchat.com/a/3b514d26-ed1a-4b07-bc90-af7ded601a1b/open/conversation/57219238-1e0c-4b7d-abce-127d65417705';
        email.htmlBody = bodyEmail;
        Messaging.InboundEmailResult result = integrationInstance.handleInboundEmail(email, null);
        
        Messaging.InboundEmail emails = new Messaging.InboundEmail();
        emails.subject = 'Test Email Subject';
        String bodyEmails ='Technical Support Analyst: Shruti Pandey - shruti.pandey@zycus.com_______________/nClient Email Address: shruti.pandey@zycus.com';
        bodyEmails +='_______________/nClient Name: Paul Flohr _______________/nTenant Name: {user.properties.tenantName} _______________/nClient Name: Paul Flohr _______________/nRegion: PROD _______________/nProduct Page: DewDrops Home_______________/n------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------/n** Chat Transcript **_______________/nPaul 17-Apr-24, 17:49 Hello ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------/nChat Conversation URL: https://zycus.freshchat.com/a/3b514d26-ed1a-4b07-bc90-af7ded601a1b/open/conversation/57219238-1e0c-4b7d-abce-127d65417705';
        emails.htmlBody = bodyEmails;       
        Messaging.InboundEmailResult results = integrationInstance.handleInboundEmail(emails, null);
        
        // Retrieve the inserted Case 
        List<Case> insertedCases = [SELECT Id, Subject, Description, Origin, RecordTypeId, OwnerId FROM Case];
        //System.assertEquals(1, insertedCases.size(), 'One Case should have been inserted');
        
        // Verify the Case details
        Case insertedCase = insertedCases[0];
        
    }
    
    @isTest
    static void testGetAgentUserByEmail(){
        Profile p = [SELECT Id
                     FROM Profile
                     WHERE Name = 'Remedyforce Administrator IM'
                     limit 1];
        User u = new User(
            Alias = 'st', 
            Email = 'test@example.com', 
            EmailEncodingKey = 'UTF-8', 
            LastName = 'ABC', 
            LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', 
            ProfileId = p.Id, 
            UserName = 'testuser9878@example.com',
            TimeZoneSidKey = 'Asia/Kolkata'
        );
        insert u;
        
        VLSF_FreshChatIntegration integrationInstance = new VLSF_FreshChatIntegration();
        User retrievedUser = integrationInstance.getAgentUserByEmail('test@example.com');
        System.debug('retrievedUser::' + retrievedUser);
        System.assertEquals(u.Id, retrievedUser.Id, 'Incorrect user retrieval');
    }
    
    @isTest
    static void testExtractClientEmailAddress(){
        String body = 'Client Email Address: client@example.com_';
        String expectedEmail = 'client@example.com';
        String extractedEmail = VLSF_FreshChatIntegration.extractClientEmailAddress(body);
        System.debug('extractedEmail::' + extractedEmail);
        System.assertEquals(expectedEmail, extractedEmail, 'Incorrect client email extraction');
    }
    
    
    
    @isTest
    static void testGetRecordTypeId(){
        RecordType testRecordType = [SELECT Id, DeveloperName
                                     FROM RecordType
                                     WHERE SObjectType = 'Case'
                                     LIMIT 1];
        VLSF_FreshChatIntegration integrationInstance = new VLSF_FreshChatIntegration();
        Id recordTypeId = integrationInstance.getRecordTypeId(testRecordType.DeveloperName);
        System.debug('recordTypeId::' + recordTypeId);
        System.assertEquals(testRecordType.Id, recordTypeId, 'Incorrect Record Type Id retrieval');
    }
    
    @isTest
    static void testGetDefaultRecordTypeId(){
        VLSF_FreshChatIntegration integrationInstance = new VLSF_FreshChatIntegration();
        Id defaultRecordTypeId = integrationInstance.getDefaultRecordTypeId();
        System.debug('defaultRecordTypeId::' + defaultRecordTypeId);
        System.assertNotEquals(null, defaultRecordTypeId, 'Default Record Type Id not retrieved');
    }
    
}