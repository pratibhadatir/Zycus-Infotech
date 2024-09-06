trigger Trigger_Incident on BMCServiceDesk__Incident__c (before update) {
   System.debug('Trigger_Incident starting');
   System.debug('Flag ' + TriggerFlag.getUpdateFlag());
    String closedID = StatusUpdate.getIdForStatus('CLOSED');
  if(TriggerFlag.getUpdateFlag()){ // To prevent calling this trigger two times.
    for (BMCServiceDesk__Incident__c inc : Trigger.new) {
	 	BMCServiceDesk__Incident__c oldInc = Trigger.oldMap.get(inc.Id);
        if(inc.ownerID != oldInc.OwnerId){
            System.debug('old queue name' + oldInc.BMCServiceDesk__queueName__c);
            System.debug('old queue name' + inc.BMCServiceDesk__queueName__c);
        	inc.BMCServiceDesk__respondedDateTime__c = null;
            inc.BMCServiceDesk__responseDateTime__c =  null ;
           
            System.debug('Reseted responsedate value'); 
            
            if(string.valueOf(inc.OwnerId).startsWith('005')){
               //owner is User
               System.debug('user found');
            }
            if(string.valueOf(inc.ownerID).startsWith('00G')){
               //owner is Queue
               System.debug('Queue found');
               inc.queueChangeCount__c = inc.queueChangeCount__c + 1 ;
               System.debug('queue change count ' + inc.queueChangeCount__c);
               inc.First_Assignment__c = 'L' + inc.queueChangeCount__c;
            }
        } 
        if(inc.BMCServiceDesk__FKStatus__c == closedID){
            if(Linked_Release_Incidents.isLinkedToRelease(inc.Name)==TRUE){
                inc.addError('You can not close the incident which is linked to release.');
            }
        }
             
	}
      
      TriggerFlag.setUpdateFlag(); //To prevent the update trigger recursion.   
  }    

    System.debug('Trigger_Incident ending');
   
}