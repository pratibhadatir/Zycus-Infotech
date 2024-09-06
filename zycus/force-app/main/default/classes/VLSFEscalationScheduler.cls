global class VLSFEscalationScheduler implements Schedulable {
    
     global void execute(SchedulableContext SC) {
         
         DateTime fiveMinutesAgo = DateTime.now().addMinutes(-5);
         List<Case> casesToEscalate = [SELECT Id,caseNumber,VLSF_Priority__c,Subject,VLSF_Account_Name__c,Description,VLSF_Product__c,VLSF_Environment__c FROM Case WHERE VLSF_Priority__c = 'P2' AND VLSF_Opsgenie_Eacalated_Alert_Id__c = null AND VLSF_P2_Time_Stamp__c <= :fiveMinutesAgo ];
         system.debug(casesToEscalate);
         
         // Call the future method if there are cases to escalate
         if (!casesToEscalate.isEmpty()) {
             String jsonStringEscCase = JSON.serializePretty(casesToEscalate);
             system.debug('escalated cases...'+jsonStringEscCase);
             VLSFOpsgenieCallouts.OpsgenieEscalationCallout1(jsonStringEscCase);
             //VLSFOpsgenieCallouts.OpsgenieEscalationCallout1(new List<Id>(casesToEscalate));
         }         
     }
}