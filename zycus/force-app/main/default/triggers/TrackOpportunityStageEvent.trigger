// This trigger fires on newly inserted or reparented Events associated with Opportunities,
// and stores the oppty's current Stage value in the Opportunity Stage field
trigger TrackOpportunityStageEvent on Event (before insert, before update) {
    // Create a map between the opportunity ID and its Stage value
    Map<ID,String> oppStageMap = new Map<ID,String>();
    List<Event> oppEvents = new List<Event>();
    
    // Loop through the triggered Events and add all of the Opportunity IDs (for those associated with Opportunities)
    for (Event e : trigger.new) {
        // Only Events associated with Opportunities
        if (e.whatID!= null && ((String)e.whatID).startsWith('006')) {
            // And only newly inserted events or those being reparented to an Opportunity
            if (trigger.isInsert || (trigger.isUpdate && e.WhatID != trigger.oldMap.get(e.id).WhatID)) {
                oppStageMap.put(e.whatID,'');
                oppEvents.add(e);
            }
        }
    }
    // Query the Opportunities and add their Stage values to the map
    for (Opportunity opp : [SELECT StageName FROM Opportunity WHERE ID IN :oppStageMap.keySet()]) {
        oppStageMap.put(opp.id,opp.StageName);
    }
    // Update the Opportunity Stage field on the Event with the relevant value
    for (Event e : oppEvents) {
        e.Opportunity_Stage__c = oppStageMap.get(e.whatID);
    }
}