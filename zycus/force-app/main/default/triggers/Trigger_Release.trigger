trigger Trigger_Release on BMCServiceDesk__Release__c (after update) {
     System.debug('Trigger_Release starts');
     if(TriggerFlag.getUpdateFlag()){
        for (BMCServiceDesk__Release__c release : Trigger.new) {
            System.debug('release NAME  ' + release.Name);
            System.debug('release STATUS ID : '+release.BMCServiceDesk__FKStatus__c);
            if(release.BMCServiceDesk__FKStatus__c == StatusUpdate.getIdForStatus('RESOLVED')){
                System.debug('The problem : ' + release.name + ' is resolved');
                System.debug('Resolving linked incidents');
           		Linked_Release_Incidents.getIncident(release.name);
       		}
        }    
     }              
     System.debug('Trigger_Release ends');
  

}