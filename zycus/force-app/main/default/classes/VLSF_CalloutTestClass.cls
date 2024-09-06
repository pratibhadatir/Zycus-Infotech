@isTest
public class VLSF_CalloutTestClass {

    @isTest
    static void testMakeOpsgenieCallout() {
        // Setup test data
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        testCase.Origin = 'Event';
        testCase.VLSF_Opsgenie_Alert_Id__c = 'alert-id-123';
        insert testCase;

        // Set the mock response
        Test.setMock(HttpCalloutMock.class, new VLSF_OpsgenieCalloutMock());

        // Call the method
        Test.startTest();
        VLSF_AddNotes.makeOpsgenieCallout(testCase.Id, 'Test note content');
        Test.stopTest();

        // Assertions
        // You can add assertions to verify that the logs were created correctly.
    }

    @isTest
    static void testMakeCalloutToJira() {
        // Setup test data
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        testCase.VLSF_JIRA_Issue_Identifier__c = 'JSF-123';
        insert testCase;

        Problem testProblem = new Problem();
        testProblem.Subject = 'Test Problem';
        testProblem.VLSF_Jira_Issue_Id__c = 'JSF-456';
        insert testProblem;

        // Set the mock response
        Test.setMock(HttpCalloutMock.class, new VLSF_JiraMockHttpResponse());
        
        // Call the method
        Test.startTest();
        VLSF_AddNotes.makeCalloutToJira(testProblem.Id, 'Test note content', 'Problem');
        VLSF_AddNotes.makeCalloutToJira(testCase.Id, 'Test note content', 'Case');
        Test.stopTest();

        // Assertions
        // You can add assertions to verify that the logs were created correctly.
    }
}