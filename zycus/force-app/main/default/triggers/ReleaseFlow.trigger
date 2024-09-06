trigger ReleaseFlow on BMCServiceDesk__Task__c (after update,after insert) { //Trigger on BMC installed Task.
  System.debug('Trigger Release Flow Started');
 
     System.debug('Trigger.UpdateFlag value ' + TriggerFlag.getUpdateFlag());
    
  /********    This trigger will only comes in use when RM test the build on sandbox is rejected.   ********/
  if(TriggerFlag.getUpdateFlag()){
     if (Trigger.isUpdate) {
         for (BMCServiceDesk__Task__c task : Trigger.new) {
             System.debug('Trigger Operation being performed for task  : ' + task.Name );
             System.debug(' Approval flag value for the given Task  : ' + task.approvalFlag__c );
             System.debug('Release name for the given Task  : ' + task.BMCServiceDesk__FKRelease__r.Name );
             System.debug('Release id for given Task  : ' + task.BMCServiceDesk__FKRelease__c );
             
             
             if((task.approvalFlag__c  == 'No' ) && task.BMCServiceDesk__taskDescription__c == 'Deploy the release on sandbox'){
                 // StatusUpdate.updateStatus(task.Name,task.approvalFlag__c); 
                 ReleaseFlow.reopenTaskFromDevProvidesBuild(task.Name); //dev provides the build has been removed. AND AGAIN added.
                
             }
             
             if(task.BMCServiceDesk__Status_ID__c == 'closed'){     // When a task is closed check if next task is waiting for reopen.
                 ReleaseFlow.reOpenWaitingTask(task.Name,task.BMCServiceDesk__templateOrder__c );
               
             }
             
             if(task.Invoke_Task_Rm_TO_Review_Failure__c == true){
                 System.debug('Invoking RM_TO_REVIEW_THE_FAILURE_TASK');
                 Failure_Task_Creation.createTask(task.BMCServiceDesk__FKRelease__c, task.BMCServiceDesk__templateOrder__c);
                
             }
             
             if(task.BMCServiceDesk__taskDescription__c == 'RM to review failure'){
                System.debug('Failed due to ' +  task.Failed_Due_to__c +  'task name '  + task.name);
                ReleaseFlow.reopenTasksBasedOnFailure(task.id, task.Failed_Due_to__c) ; 
             }
              
            
             
          }
                
     }
      
      if (Trigger.isInsert) {
           for (BMCServiceDesk__Task__c var_task : Trigger.new) {
                /*** start here ****/
                System.debug('Current task description : ' + var_task.BMCServiceDesk__taskDescription__c);
                System.debug('name: ' + var_task.name);
                System.debug('id : ' + var_task.id);
              	setOwnerName.updateOwnerName(var_task.name);
               // Set_Task_Fields_Captured_In_Release.setFields(var_task.name);
                /**** ends ******** */
               
            }
          }  
        
  }   
    
   
    System.debug('Trigger Release Flow Ends');

}