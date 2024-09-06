trigger ResolveLinkedIncidentsOfProblem on BMCServiceDesk__Problem__c (after update) {
    String resolvedID = StatusUpdate.getIdForStatus('RESOLVED');
    if(TriggerFlag.getUpdateFlag()){
        System.debug('Trigger ResolveLinkedIncidentsOfProblem started');
        for (BMCServiceDesk__Problem__c pbm : Trigger.new) {
            System.debug('PBM NAME  ' + pbm.Name);
            System.debug('PBM STATUS ID : '+pbm.BMCServiceDesk__FKStatus__c);
            if(pbm.BMCServiceDesk__FKStatus__c == resolvedID){
                System.debug('The problem : ' + pbm.name + ' is resolved');
                System.debug('Resolving linked incidents');
           		Linked_Problem_Incidents.getIncident(pbm.name);
            }
       }               
        System.debug('Trigger ResolveLinkedIncidentsOfProblem ends');
    }
}