global class VLSFOpsgenieCallouts {
    public static String apiKey;
    @future(callout=true)
    WebService static void xRESTCall(String endpoint, String payload){
        String caseNumber;
        try {
            HttpRequest req = new HttpRequest();
            caseNumber = payload.substringBetween('"caseNumber" :',',');
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setBody(payload);
            req.setHeader('Content-Type', 'application/json');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('Response: ' + res.getBody());
            VLSF_ExceptionLog.SuccessLog(res.getBody(),caseNumber);
        } 
        
        catch (Exception e) {
            System.debug('General error: ' + e.getMessage());
            VLSF_ExceptionLog.ErrorLog(e.getMessage(),caseNumber);
        }
    }
    
    @future(callout=true)
    Public static void xAckAlert(String payload){
        String caseNumber;
        try {
            system.debug('payload..'+payload);
            String endpoint = payload.substringBetween('"ep" :',',');
            system.debug('endpoint....'+endpoint);
            String apiKey = payload.substringBetween('"apikey" :','}');
            system.debug('apiKey....'+apiKey);
            caseNumber = payload.substringBetween('"caseNumber" :',',');
            system.debug('caseNumber....'+caseNumber);
            String note = payload.substringBetween('"note" :',',');
            system.debug('note....'+note);
            Map<String, Object> bodyMap = new Map<String, Object>{
                'note' => + note
            };               
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setBody(JSON.serialize(bodyMap));
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization','GenieKey '+apiKey);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('Response: ' + res.getBody());
            VLSF_ExceptionLog.SuccessLog(res.getBody(),caseNumber);
        } 
        
        catch (Exception e) {
            System.debug('General error: ' + e.getMessage());
            VLSF_ExceptionLog.ErrorLog(e.getMessage(),caseNumber);
        }
    }
    
    @InvocableMethod
    public static void invokeP2EscalationCallout(List<Case> P2Escalation){   
        
        String jsonStringEscCase = JSON.serializePretty(P2Escalation);
        System.debug('string...' + jsonStringEscCase);
        OpsgenieEscalationCallout1(jsonStringEscCase);                       
    }
    
    //Escalataion Callout
    @future(callout=true)
    public static void OpsgenieEscalationCallout1(String escalationCases) {
        system.debug('Case -- '+escalationCases);
        List<Case> cases= new List<Case>();
        Map<String, String> mappings = new Map<String, String>();
        Map<String, object> valuesMap = new Map<String, object>();
        Map<String, Object> details = new Map<String, Object>();
        Map<Id,String> caseRequestId = new Map<Id,String>();
        List<String> responseReceived = new List<String>();
        if(escalationCases!=null){
            cases = (List<Case>) JSON.deserialize(escalationCases, List<Case>.class);
        } 
        List<VLSF_Opsgenie_Api_Key__mdt> configs = [SELECT Apikey__c FROM VLSF_Opsgenie_Api_Key__mdt where label = 'OpsgenieKey2' Limit 1];
        if (!configs.isEmpty()) {
            apiKey = configs[0].Apikey__c;
        }
        system.debug('Genie Key...'+apiKey);
        VLSF_caseEscMapping__mdt metadataRecords = [SELECT Mappings__c FROM VLSF_caseEscMapping__mdt where label = 'Case Esc Mapping' LIMIT 1];
        if (metadataRecords!=null){
            for(Object obj : (List<Object>)JSON.deserializeUntyped(metadataRecords.Mappings__c)){
                //convert values to map
                Map<String, Object> data = (Map<String, Object>)obj;
                valuesMap.putAll(data);
             }
             System.debug(details); // 'Name';
         }
        system.debug('mappings...'+mappings); 
        
        //List for Payload
        List<Map<String, Object>> payloadList = new List<Map<String, Object>>();
        Map<String, String> successLogs = new Map<String, String>();
        List<Exception> exceptionLogs = new List<Exception>();
        for (Case caseRecord : cases)
        {
            Map<String, Object> escalationBody = new Map<String, Object>();
            escalationBody.put('message', 'SLA:'+caseRecord.VLSF_Priority__c+' | C:' +caseRecord.CaseNumber+' | A:' +caseRecord.VLSF_Account_Name__c+' | S:'+caseRecord.Subject);
            escalationBody.put('description', caseRecord.Description);
            escalationBody.put('priority', caseRecord.VLSF_Priority__c);           
          
            for(string str : valuesMap.keyset()){
                details.put(str, caseRecord.get(string.valueOf(valuesMap.get(str))));
            }
            details.put('SalesforceEscalation','TRUE');
            system.debug('values...'+details);
            escalationBody.put('details',details);

            // Add details to payload list
            payloadList.add(escalationBody);
            
            // Serialize payload
            String payloadJson = JSON.serialize(escalationBody);
            system.debug('payloadJson...'+payloadJson); 
            
            String endpoint = 'https://api.opsgenie.com/v2/alerts';
            //HTTP method.
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST'); 
            request.setBody(payloadJson);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'GenieKey '+apiKey);
             try{
                     HttpResponse response = http.send(request);
                     //Send request           
                     if (response.getStatusCode() == 202){
                         System.debug('Opsgenie alert created successfully.'+ response.getStatusCode()+ '::Body--'+response.getBody());
                         Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                         //Get Request Id
                         String requestId = (String)responseMap.get('requestId');                   
                         //add case id and request Id in map
                         caseRequestId.put(caseRecord.Id, requestId);
                         system.debug('case request Ids...'+caseRequestId);
                         //VLSF_ExceptionLog.SuccessLog(response.getBody(),caseRecord.caseNumber); 
                         successLogs.put(response.getBody(), caseRecord.CaseNumber);
                         responseReceived.add(response.getBody());                    
                     } 
                     else{
                         // Handle callout error
                         System.debug('Opsgenie alert creation failed. Status code: ' + response.getStatusCode()+ '::Body--'+response.getBody());
                         
                     }                
             }
            catch(Exception e){
                System.debug('Opsgenie Status callout exception: ' + e.getMessage());
                //Call Exception Class
                exceptionLogs.add(e);
                //VLSF_ExceptionLog.ExceptionLog(e);
            }
            
        } 
        // Perform DML outside the loop for success logs
        if (!successLogs.isEmpty()) {
            for (String responseBody : successLogs.keySet()) {
                VLSF_ExceptionLog.SuccessLog(responseBody, successLogs.get(responseBody));
            }
        }

        // Perform DML outside the loop for exception logs
        if (!exceptionLogs.isEmpty()) {
            for (Exception e : exceptionLogs) {
                VLSF_ExceptionLog.ExceptionLog(e);
            }
        }
        if(caseRequestId.size()>0)
        {
            //Integer delayInMinutes = 5;
            System.enqueueJob(new VLSFEscalatedAlertId(caseRequestId));
            // OpsgenieRequestSet(caseRequestId);
        }
    }
    
    //Close Escalataion Callout
    @future(callout=true)
    public static void OpsgenieStatusCloseCallout(String closedCase) {
        List<Case> cases = new List<Case>();
        if(closedCase != null) {
            cases = (List<Case>) JSON.deserialize(closedCase, List<Case>.class);
            system.debug('case deserialize...'+cases);
        }
        List<VLSF_Opsgenie_Api_Key__mdt> configs = [SELECT Apikey__c FROM VLSF_Opsgenie_Api_Key__mdt where label = 'OpsgenieKey2' Limit 1];
        if (!configs.isEmpty()) {
            apiKey = configs[0].Apikey__c;
        }
        system.debug('Genie Key...'+apiKey);
        String endpoint;
        for (Case c : cases){
            
            endpoint = 'https://api.opsgenie.com/v2/alerts/' + EncodingUtil.urlEncode(c.VLSF_Opsgenie_Eacalated_Alert_Id__c, 'UTF-8') + '/close?identifierType=id';
            Http http = new Http();
            HttpRequest request = new HttpRequest();
        
            request.setMethod('POST'); 
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'GenieKey '+apiKey);
            request.setEndpoint(endpoint);
            String baseUrl = URL.getOrgDomainUrl().toExternalForm();
            // Get the URL for the Case record
            String caseUrl = baseUrl + '/' + c.Id;
            System.debug('case URL...' + caseUrl);
            
            Map<String, Object> bodyMap = new Map<String, Object>{
                'note' => c.Status + ' status for Case Number ' + c.caseNumber + ', the case URL is: ' + caseUrl
            };
            // Serialize the body    
            request.setBody(JSON.serialize(bodyMap));
            System.debug(bodyMap);
            
            try {
                HttpResponse response = http.send(request);
            if (response.getStatusCode() != 202) {
                System.debug('Opsgenie Status callout failed: ' + response.getBody());
               
            } 
            else {
                System.debug('Opsgenie Status callout successful.' + response.getBody());
                VLSF_ExceptionLog.SuccessLog(response.getBody(),c.caseNumber);
            }
            } 
            catch(Exception e) {
                System.debug('Opsgenie Status callout exception: ' + e.getMessage());
                //Call Exception Class
                VLSF_ExceptionLog.ExceptionLog(e);
            }     
            
        }
    }
    
   /* @future(callout=true)
    public static void OpsgenieEscalationStatusCallout(String escalationCases) {        
        List<Case> cases = new List<Case>();
        if(escalationCases != null) {
            cases = (List<Case>) JSON.deserialize(escalationCases, List<Case>.class);
            system.debug('case deserialize for status change...'+cases);
        }
        List<VLSF_Opsgenie_Api_Key__mdt> configs = [SELECT Apikey__c FROM VLSF_Opsgenie_Api_Key__mdt Limit 1];
        if (!configs.isEmpty()) {
            apiKey = configs[0].Apikey__c;
        }
        system.debug('Genie Key...'+apiKey);
        String endpoint;
        for(Case cse: cases){
            endpoint = 'https://api.opsgenie.com/v2/alerts/' + EncodingUtil.urlEncode(cse.VLSF_Opsgenie_Eacalated_Alert_Id__c, 'UTF-8') + '/priority?identifierType=id';
            Http http = new Http();
            HttpRequest request = new HttpRequest();
        
            request.setMethod('POST'); 
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'GenieKey '+apiKey);
            request.setEndpoint(endpoint);
            String baseUrl = URL.getOrgDomainUrl().toExternalForm();
            // Get the URL for the Case record
            String caseUrl = baseUrl + '/' + cse.Id;
            System.debug('case URL...' + caseUrl);
            
            Map<String, Object> bodyMap = new Map<String, Object>{
                'note' => 'Priority is changed to '+ cse.VLSF_Priority__c +'  for case Number ' + cse.caseNumber + ', the case URL is: ' + caseUrl
            };
            // Serialize the body    
            request.setBody(JSON.serialize(bodyMap));
            System.debug(bodyMap);
            
            try {
                HttpResponse response = http.send(request);
                if (response.getStatusCode() != 202) {
                    System.debug('Opsgenie Status callout failed: ' + response.getBody());
               
                } 
                else {
                    System.debug('Opsgenie Status callout successful.' + response.getBody());
                    VLSF_ExceptionLog.SuccessLog(response.getBody(),cse.caseNumber);
                }
            } 
            catch(Exception e) {
                System.debug('Opsgenie Status callout exception: ' + e.getMessage());
                //Call Exception Class
                VLSF_ExceptionLog.ExceptionLog(e);
            }                 
          }
        }  */   
    //////////////////////////////////////////////////////
    
  /////////////////////////////////////////////  
    global static String getPayloadStringByHandlingNull(String value) {
        return value == null ? null : '"' + value.replaceAll('[^a-zA-Z0-9\\s\\-]', '').replaceAll('\\s+', ' ') + '"';
    }

    global static String getPayloadStringByHandlingNull(DateTime value) {
        return value == null ? null : '"' + value + '"';
    }

    global static String getPayloadStringByHandlingNull(Decimal value) {
        return value == null ? null : '"' + value + '"';
    }

    global static String getPayloadStringByHandlingNull(Boolean value) {
        return value == null ? null : '"' + value + '"';
    }
}