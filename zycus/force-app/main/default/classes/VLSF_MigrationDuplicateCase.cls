public class VLSF_MigrationDuplicateCase {

    @future
    public static void processDuplicateCases() {
        // Step 1: Query to get incidents with duplicate cases
        List<AggregateResult> results = [SELECT VLSF_Link_Incident__c incidentId, COUNT(Id) caseCount
                                         FROM Case 
                                         WHERE VLSF_Link_Incident__c != null
                                         GROUP BY VLSF_Link_Incident__c
                                         HAVING COUNT(Id) > 1];

        // Step 2: Extract incident IDs from the aggregate results
        Set<Id> incidentIds = new Set<Id>();
        for (AggregateResult ar : results) {
            incidentIds.add((Id)ar.get('incidentId'));
        }

        // Step 3: Query all cases related to the incidents with duplicates
        List<Case> casesToProcess = [SELECT Id, VLSF_Link_Incident__c
                                     FROM Case
                                     WHERE VLSF_Link_Incident__c IN :incidentIds];

        // Step 4: Map to store the first case per incident and a list to hold duplicates
        Map<Id, Case> incidentToFirstCaseMap = new Map<Id, Case>();
        List<Case> casesToDelete = new List<Case>();

        // Step 5: Iterate over the cases and identify duplicates
        for (Case c : casesToProcess) {
            if (!incidentToFirstCaseMap.containsKey(c.VLSF_Link_Incident__c)) {
                // If it's the first case for this incident, keep it
                incidentToFirstCaseMap.put(c.VLSF_Link_Incident__c, c);
            } else {
                // If it's a duplicate, mark it for deletion
                casesToDelete.add(c);
            }
        }

        // Step 6: Delete the duplicate cases
        if (!casesToDelete.isEmpty()) {
            delete casesToDelete;
        }
    }
}