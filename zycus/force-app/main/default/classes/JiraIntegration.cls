public class JiraIntegration {
    
    @Future(callout=true)
    public static void createJiraTicket(String requestId) {
        // Retrieve the Cyberark Approval Request record
        Cyberark_Approval_Request__c request = [
            SELECT Id, Name, Subject__c, Case__c, Priority__c, Cyberark_WebApp_Name__c, requestor_emailID__c, Jira_Ticket_Created__c 
            FROM Cyberark_Approval_Request__c 
            WHERE Id = :requestId LIMIT 1
        ];
        
        // Prepare the JSON payload
        String payload = JSON.serialize(new Map<String, Object>{
            'fields' => new Map<String, Object>{
                'project' => new Map<String, Object>{ 'key' => 'CSSP' },
                'summary' => request.Subject__c,
                'issuetype' => new Map<String, Object>{ 'name' => 'Auto Approved Access Request' },
                'customfield_10403' => request.Case__c,
                'customfield_25300' => request.Id,
                'customfield_29124' => request.Priority__c,
                'customfield_28885' => request.Cyberark_WebApp_Name__c,
                'customfield_26108' => request.requestor_emailID__c
            }
        });
        
        // Prepare the HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://pdtzycus.atlassian.net/rest/api/2/issue');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf('JIRA-botuser@zycus.com:mED4IFtaDUnh3cTXEH3P0EAB')));
        req.setBody(payload);
        
        // Send the HTTP request
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        // Handle the response
        if (res.getStatusCode() == 201) {
            System.debug('Jira ticket created successfully.');
            
            // Update the Cyberark Approval Request record to mark Jira ticket as created
            request.Jira_Ticket_Created__c = true;
            update request;
        } else {
            System.debug('Failed to create Jira ticket: ' + res.getBody());
        }
    }
}