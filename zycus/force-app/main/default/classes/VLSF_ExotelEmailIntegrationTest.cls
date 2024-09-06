@isTest
private class VLSF_ExotelEmailIntegrationTest {
    
    @isTest
    static void testHandleInboundEmail() {
        // Test data setup
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Email Subject';
        email.plainTextBody = 'Test Email Body';
        // Set up other necessary fields in email
        
        // Instantiate the handler class
        VLSF_ExotelEmailIntegration integrationInstance = new VLSF_ExotelEmailIntegration();
        
        // Call the method to be tested
        Messaging.InboundEmailResult result = integrationInstance.handleInboundEmail(email, null);
        
        // Add assertions here if possible
        // For example, you could check if result.success is true
    }

    @isTest
    static void testExtractSipValue() {
        // Test data setup
        String emailBody = 'Test sip:somevalue Test';
        
        // Call the method to be tested
        VLSF_ExotelEmailIntegration integrationInstance = new VLSF_ExotelEmailIntegration();
        String sipValue = integrationInstance.extractSipValue(emailBody);

        // Assertions
        System.assertEquals('somevalue', sipValue);
    }

    @isTest
    static void testGetTechSupportQueue() {
        // Test data setup
        
        // Instantiate the handler class
        VLSF_ExotelEmailIntegration integrationInstance = new VLSF_ExotelEmailIntegration();
        
        // Call the method to be tested
        Group techSupportQueue = integrationInstance.getTechSupportQueue();

        // Assertions
        System.assertNotEquals(null, techSupportQueue);
        
    }
    
    @isTest
    static void testGetRecordTypeId() {
        // Test data setup
        RecordType testRecordType = [SELECT Id, DeveloperName
                                     FROM RecordType
                                     WHERE SObjectType = 'Case'
                                     LIMIT 1];
        
        // Instantiate the handler class
        VLSF_ExotelEmailIntegration integrationInstance = new VLSF_ExotelEmailIntegration();
        
        // Call the method to be tested
        Id recordTypeId = integrationInstance.getRecordTypeId(testRecordType.DeveloperName);

        // Assertions
        System.debug('recordTypeId::' + recordTypeId);
        System.assertEquals(testRecordType.Id, recordTypeId, 'Incorrect Record Type Id retrieval');
    }
    
    @isTest
    static void testGetDefaultRecordTypeId() {
        // Instantiate the handler class
        VLSF_ExotelEmailIntegration integrationInstance = new VLSF_ExotelEmailIntegration();
        
        // Call the method to be tested
        Id defaultRecordTypeId = integrationInstance.getDefaultRecordTypeId();
        
        // Assertions
        System.debug('defaultRecordTypeId::' + defaultRecordTypeId);
        System.assertNotEquals(null, defaultRecordTypeId, 'Default Record Type Id not retrieved');
    }

    @isTest
    static void testInsertTask() {
        // Test data setup
        Case newCase = new Case(/* Set up necessary fields */);
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.fromAddress = 'test@example.com'; // Set from address
        email.toAddresses = new List<String>{'recipient@example.com'}; // Set recipient address
        email.subject = 'Test Subject';
        String emailBody = 'Test Email Body';

        // Instantiate the handler class
        VLSF_ExotelEmailIntegration integrationInstance = new VLSF_ExotelEmailIntegration();
        
        // Call the method to be tested
        integrationInstance.insertTask(newCase, email, emailBody);
        
        // Add assertions here if needed
    }
}