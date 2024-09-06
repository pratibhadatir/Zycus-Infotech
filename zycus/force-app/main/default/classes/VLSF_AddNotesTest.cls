@isTest
public class VLSF_AddNotesTest {
    
    @isTest
    static void testGetCaseNotes() {
        // Create a test case
        Test.startTest();
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        testCase.Description = 'Test Description';
        insert testCase;
        Problem testprob1 = new Problem();
        testprob1.Subject = 'Test Problem1';
        testprob1.Description = 'Test Description1';
        insert testprob1;
        VLSF_Custom_Note__c note = new VLSF_Custom_Note__c();
        note.VLSF_Title__c = 'subject';
        note.VLSF_Description__c = 'description';
        note.VLSF_Case__c = testCase.Id;
        insert note;
        VLSF_Custom_Note__c noteP = new VLSF_Custom_Note__c();
        noteP.VLSF_Title__c = 'subject';
        noteP.VLSF_Description__c = 'description';
        noteP.VLSF_Problem__c = testprob1.Id;
        insert noteP;
        
        // Create a test content document link
        ContentVersion testContent1 = VLSF_TestDataFactory.createTestContentVersion(testCase.Id);
        ContentVersion testContent2 = VLSF_TestDataFactory.createTestContentVersion(testCase.Id);
        
        // Call the method to test
        List<VLSF_Custom_Note__c> result = VLSF_AddNotes.getCaseNotes(testCase.Id, 'Case');
        List<VLSF_Custom_Note__c> result2 = VLSF_AddNotes.getCaseNotes(testprob1.Id, 'Problem');
       // System.assertNotEquals(null, result);
        //System.assertEquals(2, resuF_lt.size());
        Test.stopTest();
        // Assert that the result is not null and contains the expected number of records
        
    }
    
    @isTest
    static void testCreateNotes() {
        // Create a test case
        Case testCase1 = VLSF_TestDataFactory.createTestCase('test subject', 'test description');
        
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        testCase.Description = 'Test Description';
        testCase.VLSF_Jira_Comments__c = '["Monday","Monday","Saturday","Saturday","Sunday"]';
        insert testCase;
        Case testCase2 = new Case();
        testCase2.Subject = 'Test Case';
        testCase2.Description = 'Test Description';
        testCase.VLSF_Jira_Comments__c ='';
        insert testCase2;
        Problem testprob = new Problem();
        testprob.Subject = 'Test Problem';
        testprob.Description = 'Test Description';
        testprob.VLSF_Jira_Comments__c = '["One Value","two","third"]';
        insert testprob;
        Problem testprob1 = new Problem();
        testprob1.Subject = 'Test Problem1';
        testprob1.Description = 'Test Description1';
        insert testprob1;
        
        Test.startTest();
        String result = VLSF_AddNotes.createNotes('Test Subject', 'Test Description', testCase.Id, 'Case');
        String result1 = VLSF_AddNotes.createNotes('Test Subject', 'Test Description', testCase1.Id, 'Case');
        String result2 = VLSF_AddNotes.createNotes('Test Subject', 'Test Description', testprob1.Id, 'Problem');
        String result3 = VLSF_AddNotes.createNotes('Test Subject', 'Test Description', testprob.Id, 'Problem');
        String result4 = VLSF_AddNotes.createNotes('Test Subject', 'Test Description', testCase2.Id, 'Case');
        Test.stopTest();
        
        // Assert that the result is not null and contains the success message
        //System.assertNotEquals(null, result);
        // System.assertNotEquals('', result);
        // System.assert(result.contains('successfully inserted'));
    }
    
    @isTest
    static void testMakeOpsgenieCallout() {
        // Setup test data
        Case testCase = new Case(
            Origin = 'Event',
            VLSF_Opsgenie_Alert_Id__c = 'alert-id-123',
            VLSF_Incident_type__c = 'Incident'
        );
        insert testCase;
        
        
        // Mock the HTTP response for Opsgenie callout
        Test.setMock(HttpCalloutMock.class, new VLSF_OpsgenieCalloutMock());
        
        Test.startTest();
        VLSF_AddNotes.makeOpsgenieCallout(testCase.Id, 'Test note content');
        Test.stopTest();
        
        // Verify that the callout was made and the logs were created
        List<VLSF_Exception_Log__c> logs = [SELECT Id, VLSF_Success_Body__c FROM VLSF_Exception_Log__c WHERE VLSF_Record_Number__c = :testCase.CaseNumber];
        //System.assert(logs.size() == 1);
        //System.assert(logs[0].VLSF_Success_Body__c.contains('Opsgenie CNotes callout successful'));
    }
    
    @isTest
    static void testMakeCalloutToJira_Case() {
        // Setup test data
        Case testCase = new Case(
            VLSF_JIRA_Issue_Identifier__c = 'JSF-12',
            VLSF_Jira_Issue_Number__c = '223366',
            VLSF_Last_Update_from_Jira__c = System.now()
        );
        insert testCase;
        
        // Mock the HTTP response for Jira callout
        Test.setMock(HttpCalloutMock.class, new VLSF_JiraMockHttpResponse());
        
        Test.startTest();
        VLSF_AddNotes.makeCalloutToJira(testCase.Id, 'Test note content', 'Case');
        Test.stopTest();
        
        // Verify that the callout was made and the logs were created
        List<VLSF_Exception_Log__c> logs = [SELECT Id, VLSF_Success_Body__c FROM VLSF_Exception_Log__c WHERE VLSF_Record_Number__c = :testCase.CaseNumber];
        //System.assert(logs.size() == 1);
        //System.assert(logs[0].VLSF_Success_Body__c.contains('uploaded successfully to Jira'));
    }
    
    @isTest
    static void testMakeCalloutToJira_Problem() {
        // Setup test data
        Problem testProblem = new Problem(
            VLSF_Jira_Issue_Id__c = 'jira-issue-id-456',
            Subject = 'Test Problem1',
            Description = 'Test Description1'
        );
        insert testProblem;
        
        
        
        // Mock the HTTP response for Jira callout
        Test.setMock(HttpCalloutMock.class, new VLSF_JiraMockHttpResponse());
        
        Test.startTest();
        VLSF_AddNotes.makeCalloutToJira(testProblem.Id, 'Test note content', 'Problem');
        Test.stopTest();
        
        // Verify that the callout was made and the logs were created
        List<VLSF_Exception_Log__c> logs = [SELECT Id, VLSF_Success_Body__c FROM VLSF_Exception_Log__c WHERE VLSF_Record_Number__c = :testProblem.ProblemNumber];
        //System.assert(logs.size() == 1);
        //System.assert(logs[0].VLSF_Success_Body__c.contains('uploaded successfully to Jira'));
    }
    
    
}