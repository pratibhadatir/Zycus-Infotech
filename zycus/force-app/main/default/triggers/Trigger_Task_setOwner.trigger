trigger Trigger_Task_setOwner on BMCServiceDesk__Task__c (after insert) {
    System.debug('Trigger_Task_setOwner started.');
      if(TriggerFlag.getUpdateFlag()){
          if (Trigger.isInsert) {
           for (BMCServiceDesk__Task__c var_task : Trigger.new) {
               
                System.debug('Current task description : ' + var_task.BMCServiceDesk__taskDescription__c);
                System.debug('name: ' + var_task.name);
                System.debug('id : ' + var_task.id);
              	setOwnerName.updateOwnerName(var_task.name);
                Set_Task_Fields_Captured_In_Release.setFields(var_task.name);
               
               
            }
          }     
      }    
	
        
 System.debug('Trigger_Task_setOwner ends .');
}