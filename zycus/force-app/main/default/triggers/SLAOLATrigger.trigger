trigger SLAOLATrigger on Case (before update,after update, after insert) {
    if(Trigger.isAfter && Trigger.isInsert)
    {
        List<Case> newCases=new List<Case>();
        for(Case c: Trigger.new)
        {
           
                newCases.add(c);
        }
        if(!newCases.isEmpty())
            SLAOLATriggerHandler.handleCases(newCases);
    }
    if (Trigger.isBefore && Trigger.isUpdate ) {
        List<Case> priorityChangedCases=new List<Case>();
        for(Case c: Trigger.new){
            if(c.VLSF_Priority__c != Trigger.oldMap.get(c.id).VLSF_Priority__c && c.VLSF_Incident_Type__c != 'Case'){
                priorityChangedCases.add(c);
            }       
        }
        if(!priorityChangedCases.isEmpty())
            	SLAOLATriggerHandler.handleCases(priorityChangedCases);
    }
    
    if (Trigger.isAfter && Trigger.isUpdate){
        List<Case> closedCases=new List<Case>();
        for(Case c: Trigger.new){
            if((c.Status == 'Closed' || c.VLSF_FRT_Completed__c==TRUE || c.VLSF_Sub_Team__c != Trigger.oldMap.get(c.id).VLSF_Sub_Team__c) && c.VLSF_Incident_Type__c != 'Case' ){
                closedCases.add(c);
            }
        }
        if(!closedCases.isEmpty())
            	SLAOLATriggerHandler.handleCases(closedCases);
    }
}