trigger CyberarkApprovalRequestTrigger on Cyberark_Approval_Request__c (after update) {
    /* Loop through the records and collect those that meet the criteria
    for (Cyberark_Approval_Request__c request : Trigger.new) {
        Cyberark_Approval_Request__c oldRequest = Trigger.oldMap.get(request.Id);

        // Check if the Status has changed to 'In Progress' and Jira ticket is not created yet
        if (request.Status__c == 'In Progress' && oldRequest.Status__c != 'In Progress' && !request.Jira_Ticket_Created__c) {
            // Debug log to verify the condition is met
            System.debug('Status changed to In Progress for record Id: ' + request.Id);
            
            // Call the future method to create a Jira ticket
            JiraIntegration.createJiraTicket(request.Id);
        }
    }*/
}