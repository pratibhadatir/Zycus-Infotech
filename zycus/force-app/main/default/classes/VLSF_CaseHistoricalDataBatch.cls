global class VLSF_CaseHistoricalDataBatch implements Database.Batchable<SObject>, Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query all VLSF_Case_Historical_Data__c records where VLSF_Case__c is null and VLSF_Link_Incident__c is not null
        return Database.getQueryLocator([
            SELECT Id, VLSF_Case__c, VLSF_Link_Incident__c 
            FROM VLSF_Case_Historical_Data__c 
            WHERE VLSF_Case__c = null AND VLSF_Link_Incident__c != null
        ]);
    } 

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        List<VLSF_Case_Historical_Data__c> historicalDataRecords = (List<VLSF_Case_Historical_Data__c>) scope;

        // Collect Incident Ids
        Set<Id> incidentIds = new Set<Id>();
        for (VLSF_Case_Historical_Data__c record : historicalDataRecords) {
            incidentIds.add(record.VLSF_Link_Incident__c);
        }

        // Query Cases linked to the Incidents
        Map<Id, Case> incidentToCaseMap = new Map<Id, Case>();
        for (Case caseRecord : [
            SELECT Id, VLSF_Link_Incident__c 
            FROM Case 
            WHERE VLSF_Link_Incident__c IN :incidentIds
        ]) {
            incidentToCaseMap.put(caseRecord.VLSF_Link_Incident__c, caseRecord);
        }

        // Update the historical data records with the corresponding Case Id
        List<VLSF_Case_Historical_Data__c> recordsToUpdate = new List<VLSF_Case_Historical_Data__c>();
        for (VLSF_Case_Historical_Data__c record : historicalDataRecords) {
            Case correspondingCase = incidentToCaseMap.get(record.VLSF_Link_Incident__c);
            if (correspondingCase != null) {
                record.VLSF_Case__c = correspondingCase.Id;
                recordsToUpdate.add(record);
            }
        }

        // Perform Update
        if (!recordsToUpdate.isEmpty()) {
            try {
                update recordsToUpdate;
            } catch (DmlException e) {
                // Handle DML exceptions if necessary
                System.debug('DML Exception: ' + e.getMessage());
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
        // Perform any necessary post-processing, logging, or notifications
    }
}