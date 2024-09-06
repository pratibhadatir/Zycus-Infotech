public class VLSFEscalatedAlertId implements Queueable, Database.AllowsCallouts {
    private Map<Id, String> caseIdToRequestIdMap;

    // Constructor to accept map of Case IDs and Request IDs
    public VLSFEscalatedAlertId(Map<Id, String> caseIdToRequestIdMap) {
        this.caseIdToRequestIdMap = caseIdToRequestIdMap;
    }

    public void execute(QueueableContext context) {
        List<Case> casesToUpdate = new List<Case>();
        //List<String> successLogs = new List<String>();
        List<Exception> exceptionLogs = new List<Exception>();
        Map<String, String> successLogs = new Map<String, String>();
        String apiKey;
        
        // Retrieve API key
        List<VLSF_Opsgenie_Api_Key__mdt> configs = [SELECT Apikey__c FROM VLSF_Opsgenie_Api_Key__mdt Limit 1];
        if (!configs.isEmpty()) {
            apiKey = configs[0].Apikey__c;
        }
        System.debug('Genie Key...' + apiKey);

        // Lists to hold updates
        Map<Id, String> requestIdToCaseId = new Map<Id, String>();
        
        // Iterate over the map to make callouts for each Request ID
        for (Id caseId : caseIdToRequestIdMap.keySet()) {
            String requestId = caseIdToRequestIdMap.get(caseId);
            String endpoint = 'https://api.opsgenie.com/v2/alerts/requests/' + EncodingUtil.urlEncode(requestId, 'UTF-8'); 

            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setHeader('Authorization', 'GenieKey ' + apiKey);

            Http http = new Http();
            HttpResponse response;
            
            try {
                response = http.send(request);
                // Check if the response is successful
                if (response.getStatusCode() == 200) {
                    // Parse the response
                    Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    System.debug('Response Data: ' + responseData);
                    
                    Map<String, Object> data = (Map<String, Object>) responseData.get('data');
                    System.debug('Data: ' + data);
                                    
                    if (data != null) {
                        String alertId = (String) data.get('alertId');
                        String alias = (String) data.get('alias');
                        System.debug('AlertId: ' + alertId);
                        System.debug('Alias: ' + alias);
                        
                        // Prepare Case record for update
                        Case caseToUpdate = new Case(
                            Id = caseId,
                            VLSF_Opsgenie_Eacalated_Alert_Id__c = alertId,
                            VLSF_Opsgenie_Eacalated_Alias__c = alias,
                            Case_Approval_Status__c = 'Opsgenie'
                        );

                        casesToUpdate.add(caseToUpdate);
                        //requestIdToCaseId.put(requestId, caseId);
                        successLogs.put(response.getBody(), caseId);
                    }
                } else {
                    System.debug('Failed to retrieve data for requestId ' + requestId + '. Response: ' + response.getBody());
                }
            } catch (Exception e) {
                System.debug('Exception occurred: '+ e.getLineNumber() + ': ' + e.getMessage());
                // Log exception
                //VLSF_ExceptionLog.ExceptionLog(e);
                exceptionLogs.add(e);
            }
        }

        // Perform DML operation outside the loop
        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
            System.debug('Cases Updated: ' + casesToUpdate);
            
            // Log success for each case updated
          /*  for (Case updatedCase : casesToUpdate) {
                successLogs.add('Updated Case ' + updatedCase.Id + ' with Opsgenie details');
                if (Approval.isLocked(updatedCase.Id)) {
                    //Approval.unlock(updatedCase.Id);
                }
            }*/
        }

        // Log success for each case processed
        if(!successLogs.isEmpty()){
            for (String logMessage : successLogs.keySet()) {
                VLSF_ExceptionLog.SuccessLog(logMessage,successLogs.get(logMessage));
            }
        }
        if(!exceptionLogs.isEmpty()){
            for (Exception logError : exceptionLogs) {
                VLSF_ExceptionLog.ExceptionLog(logError);
            }
        }
        
    }
}