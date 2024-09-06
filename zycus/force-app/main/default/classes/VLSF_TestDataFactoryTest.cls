@isTest
public class VLSF_TestDataFactoryTest {
   
    @isTest
    static void testBatchProcess() {
        // Set up test data and retrieve created incidents
        List<BMCServiceDesk__Incident__c> testIncidents = VLSF_TestDataFactory.createTestIncidentData();
    }

    @isTest
    static void testCreateTestCase() {
        // Create Test Case
        String subject = 'Test Subject';
        String description = 'Test Description';
        Case testCase = VLSF_TestDataFactory.createTestCase(subject, description);
        
        // Verify creation
        System.assertNotEquals(null, testCase.Id, 'Case Id should not be null');
        System.assertEquals(subject, testCase.Subject, 'Case Subject should match');
        System.assertEquals(description, testCase.Description, 'Case Description should match');
    }

    @isTest
    static void testCreateTestContentVersion() {
        // Create Content Document Link
        Case testCase = VLSF_TestDataFactory.createTestCase('Test Subject', 'Test Description');
        
        // Create Test Content Version
        ContentVersion testContent = VLSF_TestDataFactory.createTestContentVersion(testCase.Id);
        
        // Verify creation
        System.assertNotEquals(null, testContent.Id, 'ContentVersion Id should not be null');
        System.assertEquals('Test Content ', testContent.Title, 'ContentVersion Title should match');
        // Add more assertions for other fields if needed
    }

    @isTest
    static void testCreateContentDocumentLink() {
        // Create Test Content Document Link
        Case testCase = VLSF_TestDataFactory.createTestCase('Test Subject', 'Test Description');
        ContentVersion testContent = VLSF_TestDataFactory.createTestContentVersion(null);
        ContentVersion getContent = [Select Id, ContentDocumentId from ContentVersion Where Id=:testContent.Id];
        ContentDocumentLink testLink = VLSF_TestDataFactory.createContentDocumentLink(testCase.Id, getContent.ContentDocumentId);
        
        // Verify creation
        System.assertNotEquals(null, testLink.Id, 'ContentDocumentLink Id should not be null');
        System.assertEquals(testCase.Id, testLink.LinkedEntityId, 'LinkedEntityId should match');
        System.assertEquals(getContent.ContentDocumentId, testLink.ContentDocumentId, 'ContentDocumentId should match');
    }
}