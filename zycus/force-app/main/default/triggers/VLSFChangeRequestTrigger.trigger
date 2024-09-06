trigger VLSFChangeRequestTrigger on ChangeRequest (after insert, after update) {
    
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            VLSFChangeRequestHandler.handleAfterInsert(Trigger.new);
        }
    }
    //Jenkins callout after Insert 
    if(Trigger.isAfter && Trigger.isInsert){
        for (ChangeRequest cr : Trigger.new){
            if(cr.VLSF_Make_Jenkins_Callout__c == 'Yes' && cr.VLSF_Change_Type__c == 'Standard'){
                system.debug('Inside Insert.');
                String jsonStringCR = JSON.serializePretty(Trigger.new);
                VLSFChangeRequestApi.makeJenkinsCallout(jsonStringCR);                    
            }
        }
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
            List<ChangeRequest> changeRequestsToProcess = new List<ChangeRequest>();
            // Static variable to track previous VLSF_Make_Jenkins_Callout__c value
           // Boolean hasChangedToYes = false;
            for (ChangeRequest cr : Trigger.new) {
                // Check if the field has changed from No to Yes
                //if (cr.VLSF_Make_Jenkins_Callout__c == 'Yes' && (Trigger.oldMap == null || Trigger.oldMap.get(cr.Id).VLSF_Make_Jenkins_Callout__c != 'Yes')) {
                if(cr.VLSF_Make_Jenkins_Callout__c == 'Yes' && Trigger.oldMap.get(cr.Id).VLSF_Make_Jenkins_Callout__c != 'Yes' && cr.VLSF_Change_Type__c == 'Standard' && Trigger.oldMap.get(cr.Id).VLSF_Change_Type__c != 'Standard'){
                    //hasChangedToYes = true;
                   // changeRequestsToProcess.add(cr);
                   system.debug('Inside Update..');
                   String jsonStringCR = JSON.serializePretty(Trigger.new);
                   VLSFChangeRequestApi.makeJenkinsCallout(jsonStringCR); 
                }
            // Only make the API callout if there are change requests to process and the field has changed to Yes
            /*if (hasChangedToYes && !changeRequestsToProcess.isEmpty()) {
                VLSFChangeRequestApi.processChangeRequests(changeRequestsToProcess);
            }*/
        }
    }
    
}