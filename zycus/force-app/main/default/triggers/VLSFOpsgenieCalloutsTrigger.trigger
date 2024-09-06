trigger VLSFOpsgenieCalloutsTrigger on Case (after insert, after update) {

try {
    String baseUrl = URL.getOrgDomainUrl().toExternalForm();
    String apiKey;
    List<VLSF_Opsgenie_Api_Key__mdt> configs = [SELECT Apikey__c FROM VLSF_Opsgenie_Api_Key__mdt where label ='Key' Limit 1];
    if (!configs.isEmpty()) {
        apiKey = configs[0].Apikey__c;
    }
    string endpoint = 'https://api.opsgenie.com/v1/json/integrations/webhooks/salesforceservicecloud?apiKey=d1de5d37-0540-4421-aaaa-ac1c5fed7dc4';
    //Case obj = Trigger.new[0];
    
    // Trigger logic for after insert events
    if (Trigger.isAfter && Trigger.isInsert) 
    {
        System.debug('AFTER INSERT');
        //Map<Id, String> caseIds = new Map<Id, String>();
        List<Case> caseList = new List<Case>();
        for (Case obj : Trigger.new) 
        {
            System.debug('For loop After Insert');
            System.debug('Priority... '+obj.VLSF_Priority__c);
            System.debug('Status...'+obj.Status);
            System.debug('Incident Type...'+obj.VLSF_Incident_Type__c);
            System.debug('Alias...'+obj.opsgenie_alias__c);
            if ((obj.opsgenie_alias__c != '' && obj.opsgenie_alias__c != null) && obj.VLSF_Link_Incident__c == NULL) {
            
                System.debug('AFTER INSERT..For Alert id');
            //caseIds.put(case.Id, cases.VLSF_opsgenie_alias__c);
            //caseList.add(obj);

                // Get the URL for the Case record
                String caseUrl = baseUrl + '/' + obj.Id;                   
                
                string id=obj.Id;
                string caseNumber = obj.CaseNumber;
                string status = obj.Status;
                string origin = obj.Origin;
                string subject = obj.Subject;
                string description = obj.Description;                        
                string priority = obj.VLSF_Priority__c;
                datetime closedDate = obj.ClosedDate;
                datetime createdDate = obj.CreatedDate;
                String alias = obj.opsgenie_alias__c;
                String ep = 'https://api.opsgenie.com/v2/alerts/' + EncodingUtil.urlEncode(obj.opsgenie_alias__c, 'UTF-8') + '/acknowledge?identifierType=alias';
                String note = 'Case Number ' + obj.caseNumber + ' is Acknowledged. The case URL is: ' + caseUrl;
                    
                string payload= '{'+
                    '\"id\" :' + VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(id)+ ',' +
                    '\"caseNumber\" :' + VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(caseNumber)+ ',' +
                    '\"priority\" :' + VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(priority)+ ',' +
                    '\"status\" :' + VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(status)+ ',' +
                    '\"origin\" :' + VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(origin)+ ',' +
                    '\"subject\" :' + VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(subject)+ ',' +
                    '\"description\" :' + VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(description)+ ',' +
                    '\"closedDate\" :' + VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(closedDate)+ ',' +
                    '\"createdDate\" :' + VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(createdDate)+ 
                                '}';
                
                //Standard Callout Opsgenie
                VLSFOpsgenieCallouts.xRESTCall(endpoint ,payload);
                String payload2 = '{'+
                    '\"caseNumber\" :' + VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(caseNumber)+ ',' +
                    '\"priority\" :' + VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(priority)+ ',' +
                    '\"status\" :' + VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(status)+ ',' +
                    '\"ep\" :' + ep + ',' +
                    '\"note\" :' + note + ',' +
                    '\"apikey\" :' + apiKey + 
                                  '}';
               VLSFOpsgenieCallouts.xAckAlert(payload2); 
            }  
            //P1 Escalation
            if((obj.opsgenie_alias__c == '' || obj.opsgenie_alias__c== null) && obj.VLSF_Priority__c == 'P1' && (obj.VLSF_Incident_Type__c == 'Incident' || obj.VLSF_Incident_Type__c == 'Case') && obj.VLSF_Link_Incident__c == NULL && obj.VLSF_Account_Name__c == 'Internal'){
                System.debug('AFTER INSERT..For P1 immediate escalation');
                caseList.add(obj);
            }          
        }
        if(caseList.size()>0){
            String jsonStringEscCase = JSON.serializePretty(caseList);
            System.debug('string...' + jsonStringEscCase);
            VLSFOpsgenieCallouts.OpsgenieEscalationCallout1(jsonStringEscCase);
        }
    }
    // Trigger logic for after update events
    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Case> caseLists = new List<Case>();
        List<Case> closeCase = new List<Case>();
        List<case> caseStatus = new List<Case>();
        List<Case> failureRate = new List<Case>();
        Set<Id> P2caseList = new Set<Id>();
        List<Case> caseUpdate = new List<Case>();
        for (Case obj : Trigger.new){
            //P1 Escalation
            system.debug(obj.opsgenie_alias__c);
            system.debug(obj.VLSF_Priority__c);
            system.debug(Trigger.oldMap.get(obj.Id).VLSF_Priority__c);
            system.debug(obj.VLSF_P2_Time_Stamp__c);
            system.debug(obj.Status);
            system.debug(obj.CaseNumber);
            system.debug(Trigger.oldMap.get(obj.Id).Status);
            system.debug(obj.VLSF_Opsgenie_Eacalated_Alert_Id__c);
            system.debug(obj.VLSF_Impact__c);
            system.debug(obj.VLSF_Picklist_Severity__c);
            system.debug(obj.VLSF_Approved__c);
            system.debug(Trigger.oldMap.get(obj.id).VLSF_Approved__c);
            if(obj.VLSF_Priority__c == 'P1' && (obj.opsgenie_alias__c == '' || obj.opsgenie_alias__c== null) && obj.VLSF_Opsgenie_Eacalated_Alert_Id__c == NULL && obj.VLSF_Link_Incident__c == NULL && (obj.VLSF_Incident_Type__c == 'Incident' || obj.VLSF_Incident_Type__c == 'Case') && ((obj.VLSF_Account_Name__c != 'Internal' && obj.VLSF_Approved__c == true && Trigger.oldMap.get(obj.id).VLSF_Priority__c != obj.VLSF_Priority__c) || (obj.VLSF_Account_Name__c != 'Internal' && obj.VLSF_Approved__c == true && Trigger.oldMap.get(obj.id).VLSF_Approved__c != obj.VLSF_Approved__c && Trigger.oldMap.get(obj.id).VLSF_Priority__c == obj.VLSF_Priority__c && obj.Status == 'In Progress' && Trigger.oldMap.get(obj.id).Status != obj.Status ) || ( Trigger.oldMap.get(obj.id).VLSF_Priority__c != obj.VLSF_Priority__c && obj.VLSF_Account_Name__c == 'Internal'))){
                system.debug('inside escalation P1');
                caseLists.add(obj);
            }
            //Close Escalated Case
            if(obj.VLSF_Opsgenie_Eacalated_Alert_Id__c != null && obj.Status != Trigger.oldMap.get(obj.Id).Status && (obj.Status == 'Resolved' || obj.Status == 'Closed') && obj.VLSF_Link_Incident__c == NULL && (obj.opsgenie_alias__c == '' || obj.opsgenie_alias__c== null) && (obj.VLSF_Incident_Type__c == 'Incident' || obj.VLSF_Incident_Type__c == 'Case')){
                System.debug('Inside the Case closed for escalated case');
                closeCase.add(obj);
            }
           /* if((obj.opsgenie_alias__c == '' || obj.opsgenie_alias__c== null) && obj.VLSF_Priority__c == 'P2' && obj.VLSF_P2_Time_Stamp__c == null && obj.Status == 'In Progress' && Trigger.oldMap.get(obj.Id).Status == 'Pending for Approval' && obj.Status != Trigger.oldMap.get(obj.Id).Status && obj.VLSF_Opsgenie_Eacalated_Alert_Id__c == NULL){
                System.debug('AFTER UPDATE//////////////////////UPDATE THE P2 TIMESTAMP/////////////////////');
                P2caseList.add(obj.Id);
                system.debug(P2caseList);
            }
            if((obj.opsgenie_alias__c == '' || obj.opsgenie_alias__c== null) && obj.Status == 'Open' && obj.VLSF_P2_Time_Stamp__c == null && obj.VLSF_Priority__c == 'P2' && (obj.VLSF_Incident_Type__c == 'Incident' || obj.VLSF_Incident_Type__c == 'Case') && obj.VLSF_Link_Incident__c == NULL){
                System.debug('//////////////////////UPDATE THE P2 TIMESTAMP/////////////////////');
                P2caseList.add(obj.Id);
                system.debug(P2caseList);
            }  */
            //For description update (Failure rate change)
           /* if(obj.Description != Trigger.oldMap.get(obj.Id).Description  && obj.opsgenie_alias__c != null && obj.Origin == 'Event'){                     
               System.debug('Inside the Failure rate change');
               failureRate.add(obj);
            } */
            //Priority Chnage for Escalated Cases
           /* if(obj.Status != Trigger.oldMap.get(obj.Id).Status && obj.VLSF_Opsgenie_Eacalated_Alert_Id__c == NULL && obj.VLSF_Incident_Type__c == 'Incident' && (obj.opsgenie_alias__c == '' || obj.opsgenie_alias__c== null)){
                System.debug('Inside the Case status changed for escalated case');
                caseStatus.add(obj);
            } */            
        }    
        if(caseLists.size()>0){
            String jsonStringEscCase = JSON.serializePretty(caseLists);
            VLSFOpsgenieCallouts.OpsgenieEscalationCallout1(jsonStringEscCase);
        }
        if(closeCase.size()>0){
            String jsonStringEscCase = JSON.serializePretty(closeCase);
            VLSFOpsgenieCallouts.OpsgenieStatusCloseCallout(jsonStringEscCase);
        }
        if(failureRate.size()>0){
            String jsonStringFailureCase = JSON.serializePretty(failureRate);
            //VLSFOpsgenieCallouts.OpsgenieFailureRate(jsonStringFailureCase);
        }
       /* if(P2caseList.size()>0){
            system.debug('P2caseList...'+P2caseList);
            caseUpdate = [select Id,VLSF_P2_Time_Stamp__c from Case where Id IN: P2caseList];
            system.debug('caseUpdate...'+caseUpdate);
            for(Case c:caseUpdate){
                c.VLSF_P2_Time_Stamp__c = DateTime.now();
            }
            Update caseUpdate;
        }*/
    }
    } 
    catch (Exception e) {
        System.debug('Exception in the code...' + e.getMessage());
        //Call Exception Class
        VLSF_ExceptionLog.ExceptionLog(e);
    } 
}