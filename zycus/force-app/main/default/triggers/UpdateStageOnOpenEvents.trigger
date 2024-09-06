// This trigger keeps the Opportunity Stage field updated on open Events related to Opportunities.
// It fires when an Opportunity's stage is changed, then finds all open Events (i.e. with an end date
// in the future) and updates the Opportunity Stage field to the Opportunity's current stage
trigger UpdateStageOnOpenEvents on Opportunity (before update) {
    // Create a map between the IDs of the triggered Opportunities and their stages,
    // then loop through the Opportunities to populate the map
    Map<Id,String> oppStageMap = new Map<Id,String>();
    for (Opportunity opp : trigger.new) {
        if (opp.StageName != trigger.oldMap.get(opp.id).StageName) {
            oppStageMap.put(opp.id,opp.StageName);            
        }
    }
    
    // Query all open Events associated with the triggered Opportunities,
    // then assign to them the related Opportunity's current Stage value
    List<Event> events = [SELECT Opportunity_Stage__c, WhatId FROM Event WHERE WhatID IN: oppStageMap.keySet() AND EndDateTime > :Datetime.now()];
    for (Event e : events) {
        e.Opportunity_Stage__c = oppStageMap.get(e.WhatId);
    }
    update events;
}