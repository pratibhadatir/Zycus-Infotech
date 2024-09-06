// This trigger takes newly inserted, newly reparented, or newly closed Tasks associated with Opportunities
// and populates the Task's Opportunity Stage field with the current Stage value from the Opportunity
trigger TrackOpportunityStageTask on Task (before insert, before update) {
    
    Map<ID,String> oppStageMap = new Map<ID,String>(); // Create a map between the opportunity ID and its Stage value
    List<Task> oppTasks = new List<Task>(); // A list to store only those relevant Tasks (described on line 1 above)
    
    // Originally I was just checking the isClosed value of the Task, but I learned that this trigger appears to fire before
    // some separate process that updates isClosed based on the value of the selected TaskStatus. So instead, we're doing an
    // extra step by directly querying the TaskStatus values and mapping their isClosed values to their labels
    Map<String,boolean> statusMap = new Map<String,boolean>();
    for (TaskStatus status : [SELECT MasterLabel, IsClosed FROM TaskStatus])
        statusMap.put(status.MasterLabel,status.IsClosed);
    
    // Loop through the triggered Tasks and add all of the Opportunity IDs (for those associated with Opportunities)
    for (Task t : trigger.new) {
        // Before we check anything else, if a Task has been reparented (assigned a new WhatID), clear the Opportunity Stage value
        if (trigger.isUpdate && (t.WhatID != trigger.oldMap.get(t.id).WhatID)) {
            t.Opportunity_Stage__c = '';
        }

        // We've got a few layers of filters to find only the relevant Tasks here
        // First, we only want Tasks associated with Opportunities
        if (t.whatID!= null && ((String)t.whatID).indexOf('006')==0) {
            // Next, we only want either newly inserted tasks, OR reparented tasks, OR newly closed tasks
            if (trigger.isInsert || (t.whatID != trigger.oldMap.get(t.id).whatID || (statusMap.get(t.status) && !statusMap.get(trigger.oldMap.get(t.id).status)))) {
                oppTasks.add(t);
                oppStageMap.put(t.whatID,'');
            }
        }
    }
    // Query the Opportunities and add their Stage values to the map
    for (Opportunity opp : [SELECT StageName FROM Opportunity WHERE ID IN :oppStageMap.keySet()]) {
        oppStageMap.put(opp.id,opp.StageName);
    }
    // Update the Opportunity Stage field on the Task with the relevant value
    for (Task t : oppTasks) {
        t.Opportunity_Stage__c = oppStageMap.get(t.whatID);
    }
}