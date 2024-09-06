@isTest
private class VLSF_SIPAndEmailMetadataHelperTest {
    
    @isTest
    static void testGetMetadataValuesBySip() {
        // Test SIP value
        String testSipValue = 'abdullah4d9faa6b';
        
        // Call the method being tested
        Test.startTest();
        Map<String, String> metadataValues = VLSF_SIPAndEmailMetadataHelper.getMetadataValuesBySip(testSipValue);
        Test.stopTest();

        // Add assertions
        System.assertNotEquals(null, metadataValues);
        // Add more specific assertions if needed
    }
    
    @isTest
    static void testGetMetadataValuesByAnalystEmail() {
        // Test Analyst Email
        String testEmail = 'test@example.com';

        // Call the method being tested
        Test.startTest();
        Map<String, String> metadataValues = VLSF_SIPAndEmailMetadataHelper.getMetadataValuesByAnalystEmail(testEmail);
        Test.stopTest();

        // Add assertions
        System.assertNotEquals(null, metadataValues);
        // Add more specific assertions if needed
    }
    
    @isTest
    static void testGetUserBySipValue() {
        // Test SIP value
        String testSipValue = 'ABC123';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Remedyforce Administrator IM' LIMIT 1];
        
        // Create a mock User object
        User mockUser = new User( 
            Alias = 'st', 
            Email = 'test@example.com', 
            EmailEncodingKey = 'UTF-8', 
            EmployeeNumber = testSipValue, // Use the SIP value as EmployeeNumber
            LastName = 'ABC', 
            LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', 
            ProfileId = p.Id, 
            UserName = 'testuser9878@example.com',
            TimeZoneSidKey = 'Asia/Kolkata'
        );
        insert mockUser;
        
        // Call the method being tested
        Test.startTest();
        User user = VLSF_SIPAndEmailMetadataHelper.getUserBySipValue(testSipValue);
        Test.stopTest();

        // Add assertions
        System.assertNotEquals(null, user);
        // Add more specific assertions if needed
    }
    
    @isTest
    static void testGetUserBySipValue_Exception() {
        // Test SIP value
        String testSipValue = 'ABC123';
        
        // Call the method being tested
        Test.startTest();
        User user = VLSF_SIPAndEmailMetadataHelper.getUserBySipValue(testSipValue);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(null, user);
    }
    
    @isTest
    static void testGetMetadataValuesBySip_NullTeamMember() {
        // Test SIP value that should not have a matching Team Member record
        String testSipValue = 'NonExistentSIPValue';
          
        // Call the method being tested
        Test.startTest();
        Map<String, String> metadataValues = VLSF_SIPAndEmailMetadataHelper.getMetadataValuesBySip(testSipValue);
        Test.stopTest();
        
        // Add assertions
       // System.assertEquals(0, metadataValues.size(), 'No metadata should be returned for non-existent SIP value');
    }
}