@isTest
public class JiraIntegrationTest {
    
    @isTest
    static void testCreateJiraTicket() {
        // Create a test Cyberark Approval Request record
      Test.setMock(HttpCalloutMock.class, new JiraMockResponse());

        Cyberark_Approval_Request__c request = new Cyberark_Approval_Request__c(
       
            Subject__c = 'Test Subject',
            Priority__c = 'P1',
            Cyberark_WebApp_Name__c = 'Test WebApp',
            requestor_emailID__c = 'test@example.com',
            Jira_Ticket_Created__c = false
        );
        insert request;

        // Set up mock response for Http callout
        Test.setMock(HttpCalloutMock.class, new JiraMockResponse());

        // Call the method to test
        Test.startTest();
        JiraIntegration.createJiraTicket(request.Id);
        Test.stopTest();

        // Refresh the record from the database
        request = [SELECT Id, Jira_Ticket_Created__c FROM Cyberark_Approval_Request__c WHERE Id = :request.Id LIMIT 1];

        // Assert that the Jira ticket was marked as created
        System.assertEquals(true, request.Jira_Ticket_Created__c, 'Jira Ticket should be marked as created');
    }
}