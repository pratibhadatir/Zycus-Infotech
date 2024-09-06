public class VLSF_AlertIdQueueable implements Queueable, Database.AllowsCallouts {
    List<Case> caseList;
    List<Case> updateCases =new List<Case>();
    Map<Id,String> caseAlertId = new Map<Id,String>();
    

    // Constructor to pass the list of case-related strings
    public VLSF_AlertIdQueueable(String casesList) {
         if(casesList != null) {
            this.caseList = (List<Case>) JSON.deserialize(casesList, List<Case>.class);
            system.debug('case deserialize...'+caseList);
        }
       // this.caseList = cases;
    }

    // The execute method where the callout logic will be implemented
    public void execute(QueueableContext context) {
        String AlertIds;
        String apiKey;
        List<VLSF_Opsgenie_Api_Key__mdt> configs = [SELECT Apikey__c FROM VLSF_Opsgenie_Api_Key__mdt Limit 1];
            if (!configs.isEmpty()) {
                apiKey = configs[0].Apikey__c;
        }
        system.debug('Genie Key...'+apiKey);
        List<Case> updateCases = new List<Case>();
        for (Case caseInfo : caseList) {
            system.debug('caseInfo...'+caseInfo);
            // Assuming caseInfo is an Opsgenie Alias or something that you can use directly in the callout
            String endpoint = 'https://api.opsgenie.com/v2/alerts/' + EncodingUtil.urlEncode(caseInfo.opsgenie_alias__c, 'UTF-8') + '?identifierType=alias'; 
            system.debug('endpoint...'+endpoint);
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setHeader('Authorization', 'GenieKey '+apiKey);
            system.debug('request...'+request);
            Http http = new Http();
            try {
                HttpResponse response = http.send(request);
                system.debug('response...'+response);

                if (response.getStatusCode() == 200) {
                    system.debug('Inside 200');
                    String responseBody = response.getBody();
                    VLSF_ExceptionLog.SuccessLog(responseBody,caseInfo.caseNumber);
                    system.debug('response body...'+responseBody);
                    Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);                   
                    Map<String, Object> data = (Map<String, Object>)parsedResponse.get('data');

                    if (data.containsKey('id')) {
                        AlertIds = (String) data.get('id');
                        System.debug('Alert Id is...' + AlertIds);
                        
                        //Store in Map the Case Id and Alert id
                        //caseAlertId.put(caseInfo.Id,AlertIds);
                        Case caseRecord = new Case();
                        caseRecord.Id = caseInfo.Id;
                        //caseRecord.Id = caseInfo.Id;
  
                        caseRecord.VLSF_Opsgenie_Alert_Id__c = AlertIds;
                        
                      updateCases.add(caseRecord);
                }
                else {
                    System.debug('Callout failed for Case Info ' + caseInfo + ': ' + response.getBody());
                }
                }
            } catch (Exception e) {
                System.debug('Exception during callout for Case Info ' + caseInfo + ': ' + e.getMessage());
                //Call Exception Class
                VLSF_ExceptionLog.ExceptionLog(e);
            }        
 /*       if(caseAlertId.size()>0){
            system.debug('Inside the Update');
            for(Id caseIds: caseAlertId.keyset()){
                Case cases = new Case();
                cases.Id = caseIds;
                if(Approval.isLocked(cases.Id)){
                    system.debug('Inside the Update');
                    Approval.unlock(cases.Id);
                    cases.VLSF_Opsgenie_Alert_Id__c = caseAlertId.get(caseIds);
                    updateCases.add(cases);                   
                }                
            }
            if(updateCases.size()>0){
                update updateCases;
            }           
        } */           
    }
        if(updateCases.size()>0)
        {
            update updateCases;
        }
}
}