public class ChangeRequestTaskUpdater {
    
    public static void updateChangeRequestCheckbox1(List<Task> taskList){
        
        Set<Id> changeId = new Set<Id>();
        
        for(Task task : taskList){
            changeId.add(task.WhatId);
        }
        
        List<Task> tasksToUpdate = [SELECT Id, WhatId, Status FROM Task WHERE WhatId IN :changeId];
        
        Boolean flag = true; // Initialize flag to true initially
        
        for(Task tk : tasksToUpdate){
            if(tk.Status != 'RESOLVED'){ // Changed 'RESOLVED' to 'Completed' assuming this is the status to check
                flag = false; // Set flag to false if any task is not completed
                break; // No need to continue checking, exit loop
            }
        }
        
        // Update ChangeRequest only if all related tasks are completed
        if(flag && !changeId.isEmpty()) {
            List<ChangeRequest> changeRequestsToUpdate = [SELECT Id, VLSF_Jenkins_Callout__c FROM ChangeRequest WHERE Id IN :changeId];
            
            for(ChangeRequest cr : changeRequestsToUpdate) {
                cr.VLSF_Jenkins_Callout__c = true; // Set the checkbox field to true
                System.debug('cr :::' +cr);
            }
            
            // Update the ChangeRequest records
            update changeRequestsToUpdate;
            
            // Make API callout if checkbox is true
            for (ChangeRequest cr : changeRequestsToUpdate) {
                if (cr.VLSF_Jenkins_Callout__c == true) {
                    String crJson = JSON.serializePretty(cr); // Serialize the ChangeRequest object
                   
                    List<ChangeRequest> crList = new List<ChangeRequest>();
                    crList.add(cr);
                    String crJso = JSON.serializePretty(crList); // Serialize the List of ChangeRequest objects
                     VLSFChangeRequestApi.makeJenkinsCallout(crJso); // Pass serialized JSON string
                    break; // No need to continue iterating if one ChangeRequest has the checkbox set to true
                }
            }
        }
    }
}