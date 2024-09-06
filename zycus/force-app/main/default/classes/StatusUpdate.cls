public class StatusUpdate {
 
   
    
 /********* Below method will reopen the task whose task number is provided.   ***************/
    
    public static void updateStatus(String taskNumber){ 
         System.debug('starting updateStatus()');        
        
		 /********* Below Query is retrieving all the necessary info of given task.               ***************/
        
         BMCServiceDesk__Task__c task = [select BMCServiceDesk__FKStatus__r.Name,Task_Reopen_Count__c from BMCServiceDesk__Task__c where Name = :taskNumber LIMIT 1];                
          
         Decimal count = Integer.valueOf(task.Task_Reopen_Count__c);
         count++ ;
        
         task.BMCServiceDesk__FKStatus__c = getIdForStatus('OPENED') ;//set the status as open.

         task.approvalFlag__c = 'default' ;
       //  task.isLocked__c = False;
       //  task.BMCServiceDesk__state__c = true;
         task.Task_Reopen_Count__c = count ;
         task.wilReopen__c = false ;
         task.Invoke_Task_Rm_TO_Review_Failure__c = false;
       //  task.BMCServiceDesk__isReopened__c = true ; // setting it true when reopening it.
       
         try{
            TriggerFlag.setUpdateFlag(); //To prevent the update trigger recursion.   
            System.debug('Task : ' + task.BMCServiceDesk__taskDescription__c + 'is in Reopen mode');  
            update task ;   
            
         }
         Catch(Exception e){
            System.debug('Getting error' + e.getMessage());     
         }
        
         System.debug('ending updateStatus()');               
    }
    
    
 /**********    This method will set the willReopen field.   ***************/
     public static void setWillReOpen(String taskNumber){
         System.debug(' starting setWillReOpen() for the task : ' + taskNumber);        
        
         BMCServiceDesk__Task__c task = [select BMCServiceDesk__FKStatus__r.Name,Task_Reopen_Count__c from BMCServiceDesk__Task__c where Name = :taskNumber LIMIT 1];                
         
         task.wilReopen__c = true ;      
         task.Invoke_Task_Rm_TO_Review_Failure__c = false;
         
         try{
              TriggerFlag.setUpdateFlag(); //To prevent the update trigger recursion.   
              update task ;   
         }
         Catch(Exception e){
             System.debug('Getting error' + e.getMessage());     
         }
        
         System.debug('ending setWillReOpen() for the task : ' + taskNumber);                   
    }
    
 /********** This method will reopen all the task which have willReopenFlag true and its order number is one more than last task. ********/ 
    
    public static void reOpenWaitingTasks(Decimal orderNumber,String releaseName){
        System.debug('Starting reOpenWaitingTasks()');
        
        System.debug('Release Name ' + releaseName);
        
        BMCServiceDesk__Release__c  release   = [Select r.Name, (Select Name, BMCServiceDesk__Status_ID__c,wilReopen__c,BMCServiceDesk__templateOrder__c,BMCServiceDesk__taskDescription__c From BMCServiceDesk__Tasks__r ORDER BY Name) 
                                      From BMCServiceDesk__Release__c r where name =:releaseName];

		/********* Finding if all the task with given order number are closed ***************/
        
        for(BMCServiceDesk__Task__c taskTemp : release.BMCServiceDesk__Tasks__r){
            
            if(taskTemp.BMCServiceDesk__templateOrder__c != orderNumber){
                continue;
            }

            if(taskTemp.wilReopen__c && taskTemp.BMCServiceDesk__templateOrder__c == orderNumber){
               System.debug('Reopening waiting task ' + taskTemp.Name + ' Description : ' + taskTemp.BMCServiceDesk__taskDescription__c );
               updateStatus(taskTemp.Name);
               
		    } 
            else{
				System.debug('task with order number ' + taskTemp.BMCServiceDesk__templateOrder__c + ' and description ' + taskTemp.BMCServiceDesk__taskDescription__c  + ' is not waiting for reopen');                
            }
        }
        
        System.debug('Ending reOpenWaitingTasks()');
    }
    
    public static void updateStatusAsRejected(String num){
         System.debug('Starting updateStatusAsRejected()');       
         BMCServiceDesk__Incident__c inc = [select BMCServiceDesk__FKStatus__c from BMCServiceDesk__Incident__c where Name = :num LIMIT 1];                
         inc.BMCServiceDesk__FKStatus__c = StatusUpdate.getIdForStatus('Rejected') ;
        try{
              TriggerFlag.setUpdateFlag(); //To prevent the update trigger recursion.   
              update inc ;   
         }
         Catch(Exception e){
             System.debug('Getting error' + e.getMessage());     
         }
        
        System.debug('Ending updateStatusAsRejected()');       

    }
    
    public static void updateStatusAsRejectedForTask(String num){
         System.debug('Starting updateStatusAsRejectedForTask()');       
         BMCServiceDesk__Task__c task = [select BMCServiceDesk__FKStatus__c from BMCServiceDesk__Task__c where Name = :num LIMIT 1];                
         task.BMCServiceDesk__FKStatus__c = StatusUpdate.getIdForStatus('Rejected') ;
        try{
              TriggerFlag.setUpdateFlag(); //To prevent the update trigger recursion.   
              update task ;   
         }
         Catch(Exception e){
             System.debug('Getting error' + e.getMessage());     
         }
        
        System.debug('Ending updateStatusAsRejectedForTask()');       

    }

 //!! The below method will return the status id for a specific status.
    public static String getIdForStatus(String statusName){
         BMCServiceDesk__Status__c status = [Select id from BMCServiceDesk__Status__c where name = :statusName limit 1];	        
         String statusID = status.Id ;      
         System.debug('Returning Status ID ' + statusID + ' For Status : ' + statusName);
         return statusID ;        
    }   
    
     public static String getIdForQueue(String queueName){ // one copy of this method also declared in setOwnerName class.
         Group queue = [select id,name from Group where name = :queueName limit 1];	        
         String qID = queue.Id ;      
         System.debug('Returning Q ID ' + qID + ' For queueName : ' + queueName);
         return qID ;        
    }   

}