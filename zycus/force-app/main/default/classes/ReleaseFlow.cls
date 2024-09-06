public class ReleaseFlow {
  /**************** This will reopen the task when RM test the build on SANDBOX is rejected.    ********************/
    

    
 /******* This method will work when TASK: RM to review the failure occur.   **************/
    
    public static void reopenTasksBasedOnFailure(String taskId,String failureReason){
        System.debug('Starting reopenTaskBasedOnFailure() ');
        
        String taskNumber = getTaskNumber(taskId);
        
        if(failureReason == 'UAT'){
            reopenTaskFromUAT(taskNumber) ;
        }
        else if(failureReason == 'Dev'){
            reopenTaskFromDevProvidesBuild(taskNumber) ; //task dev provides the build has been removed from flow
             // reopenTaskFromRmTestTheBuild(taskNumber) ; again roll back the requirement
        }
        else if(failureReason == 'RM'){
            reopenTaskFromRmTestTheBuild(taskNumber) ;
        }
             
        System.debug('Ending reopenTaskBasedOnFailure() ');
    }
    
 /************** This method will reopen all the task which comes from TASK:Perform UAT.  *************/
    
    public static void reopenTaskFromUAT(String taskNumber){
    	System.debug('Starting reopenTaskFromUAT() ');    
        
        String releaseName = getReleaseName(taskNumber) ;
        
        System.debug('Retrieving releaseName :' + releaseName);
        
        /***** Retrieving task in the given release and setting willReopnen all the task from UAT.  *************/
        
        BMCServiceDesk__Release__c  release   = [Select r.Name, (Select Name, BMCServiceDesk__Status_ID__c,BMCServiceDesk__templateOrder__c,BMCServiceDesk__taskDescription__c From BMCServiceDesk__Tasks__r ORDER BY Name) 
                                      From BMCServiceDesk__Release__c r where name =:releaseName];
        
        Boolean UATFLAG = FALSE ;
        
        for(BMCServiceDesk__Task__c taskTemp : release.BMCServiceDesk__Tasks__r){
            System.debug('execution order  number  of task ' + taskTemp.Name + ' is ' + taskTemp.BMCServiceDesk__templateOrder__c + ' and status : ' + taskTemp.BMCServiceDesk__Status_ID__c  + ' description : ' +taskTemp.BMCServiceDesk__taskDescription__c );  
           
            if(taskTemp.BMCServiceDesk__taskDescription__c == 'RM to review failure'){  // prevent any updataion to this task                      
                continue ;
            }
            
            if(taskTemp.BMCServiceDesk__Status_ID__c != 'OPENED' && UATFLAG ){ // all the task inside this are after UAT task is reached
                System.debug('Setting field will_Reopen for the task : ' + taskTemp.Name);
                StatusUpdate.setWillReOpen(taskTemp.Name);                        
            }
            else{
                System.debug('Task ' + taskTemp.BMCServiceDesk__taskDescription__c  + 'is not eligible for reopen. and UATFLAG : ' + UATFLAG);
            }  
            
             if(taskTemp.BMCServiceDesk__taskDescription__c != 'Perform UAT'){                        
                continue ;
            }
            else{
                UATFLAG = TRUE ; // we reached the task UAT
                System.debug('Reopening the task UAT and dynamic description: ' + taskTemp.BMCServiceDesk__taskDescription__c);
                StatusUpdate.updateStatus(taskTemp.Name); // reopening the task.
                
            }
         }

        System.debug('Ending reopenTaskFromUAT()');    
    }
	
   
 /***************   This will reopen all the task which comes from TASK:Dev provides the build.   *****************/
    
    public static void reopenTaskFromDevProvidesBuild(String taskNumber){
        System.debug('starting reopenTaskFromDevProvidesBuild() ');    
        
        String releaseName = getReleaseName(taskNumber) ;
        
        System.debug('Retrieving releaseName :' + releaseName);
        
        BMCServiceDesk__Release__c  release   = [Select r.Name, (Select Name, BMCServiceDesk__Status_ID__c,BMCServiceDesk__templateOrder__c,BMCServiceDesk__taskDescription__c From BMCServiceDesk__Tasks__r ORDER BY Name) 
                                      From BMCServiceDesk__Release__c r where name =:releaseName];
        
        for(BMCServiceDesk__Task__c taskTemp : release.BMCServiceDesk__Tasks__r){
           System.debug('execution order  number  of task ' + taskTemp.Name + ' is ' + taskTemp.BMCServiceDesk__templateOrder__c + ' and status : ' + taskTemp.BMCServiceDesk__Status_ID__c  + ' description : ' +taskTemp.BMCServiceDesk__taskDescription__c );  
          
			
            if(taskTemp.BMCServiceDesk__taskDescription__c == 'RM to review failure'){  // prevent any updataion to this task                      
                continue ;
            }            
            
           if(taskTemp.BMCServiceDesk__Status_ID__c != 'OPENED' ){ // will work only for the closed task.                
               if(taskTemp.BMCServiceDesk__templateOrder__c == 2 ){ // will open all the task with template order 2.
                   System.debug('ReOpening all the task with execution order 2');
		           System.debug('description of task with execution order 2 is : ' + taskTemp.BMCServiceDesk__taskDescription__c);                   
                   StatusUpdate.updateStatus(taskTemp.Name); // reopening the task.
               }
               else{
                   System.debug('Setting will_Reopen for the task : ' + taskTemp.Name);
                   StatusUpdate.setWillReOpen(taskTemp.Name);
               }
            } 
            else{
                System.debug('Task ' + taskTemp.BMCServiceDesk__taskDescription__c  + 'is already opened.');
            }
         }
        
        System.debug(' ending reopenTaskFromDevProvidesBuild() ');           
    }
    
  /****** This method  will reopen all the task which comes from RM  test the build on Sandbox.  *******/
    
    public static void reopenTaskFromRmTestTheBuild(String taskNumber){
        System.debug('startin reopenTaskFromRmTestTheBuild(String taskNumber) ');   
        
        String releaseName = getReleaseName(taskNumber) ;
        
        System.debug('Retrieving releaseName :' + releaseName);
        
        /***** Retrieving task in the given release and setting willReopnen all the task from UAT.  *************/
        
        BMCServiceDesk__Release__c  release   = [Select r.Name, (Select Name, BMCServiceDesk__Status_ID__c,BMCServiceDesk__templateOrder__c,BMCServiceDesk__taskDescription__c From BMCServiceDesk__Tasks__r ORDER BY Name) 
                                      From BMCServiceDesk__Release__c r where name =:releaseName];        
        Boolean RMFLAG = FALSE ;
        
        for(BMCServiceDesk__Task__c taskTemp : release.BMCServiceDesk__Tasks__r){
            System.debug('execution order  number  of task ' + taskTemp.Name + ' is ' + taskTemp.BMCServiceDesk__templateOrder__c + ' and status : ' + taskTemp.BMCServiceDesk__Status_ID__c  + ' description : ' +taskTemp.BMCServiceDesk__taskDescription__c );  
            
            
            if(taskTemp.BMCServiceDesk__taskDescription__c == 'RM to review failure'){  // prevent any updataion to this task                      
                continue ;
            }
             
            if(taskTemp.BMCServiceDesk__Status_ID__c != 'OPENED' && RMFLAG ){ // all the task inside this are after RM task is reached.
                System.debug('Setting field will_Reopen for the task : ' + taskTemp.Name);
                StatusUpdate.setWillReOpen(taskTemp.Name);                        
            }
            else{ // a condition will come when task will be RM which will be test below to make the RMFlag true
                System.debug('Task ' + taskTemp.BMCServiceDesk__taskDescription__c  + 'is not eligible for reopen. and UATFLAG : ' + RMFLAG);
            }
            
            if(taskTemp.BMCServiceDesk__taskDescription__c != 'Deploy the release on sandbox'){                        
                System.debug('Getting description ' +taskTemp.BMCServiceDesk__taskDescription__c );
                continue ;
            }
            else{
                RMFLAG = TRUE ; // we reached the task RM test.
                System.debug('Reopening the task RM and dynamic description: ' + taskTemp.BMCServiceDesk__taskDescription__c + ' taskNUm : ' + taskTemp.Name);
                StatusUpdate.updateStatus(taskTemp.Name); // reopening the task.
            }
            
            
           
         }
        System.debug(' ending reopenTaskFromRmTestTheBuild() ' );           
    }
   
  /********** This method will reopen the task which has will_reopen field as true ***********/  
    public static void reOpenWaitingTask(String taskName,Decimal orderNumber){
        System.debug('starting reOpenWaitingTask()');
        
        // Fetch the task name.
        // Find the associated release.
        // Find the assocaited order number.
        // Find if all the task with the given order numbers are closed
        // if not closed return
        // if closed then find all the task with ordernumber + 1 and reopen it.
        
        Boolean taskCloseFlag = true ;
        
        String releaseName = getReleaseName(taskName);
        
        System.debug('Retreiving release name  ' + releaseName);
                	
        BMCServiceDesk__Release__c  release   = [Select r.Name, (Select Name, wilReopen__c,BMCServiceDesk__Status_ID__c,BMCServiceDesk__templateOrder__c,BMCServiceDesk__taskDescription__c From BMCServiceDesk__Tasks__r ORDER BY Name) 
                                      From BMCServiceDesk__Release__c r where name =:releaseName];

		/********* Finding  all the task with given order number are closed ***************/
        
        for(BMCServiceDesk__Task__c taskTemp : release.BMCServiceDesk__Tasks__r){
           System.debug('execution order  number  of task ' + taskTemp.Name + ' is ' + taskTemp.BMCServiceDesk__templateOrder__c + ' and status : ' + taskTemp.BMCServiceDesk__Status_ID__c  + ' description : ' +taskTemp.BMCServiceDesk__taskDescription__c );  
		   /** first check if any task in the given order is closed and waiting for reopen then reopen it.  **/
           if(taskTemp.BMCServiceDesk__Status_ID__c != 'CLOSED' && taskTemp.BMCServiceDesk__templateOrder__c == orderNumber){ 				// will not work for the closed task.                
		           System.debug('description of task with open state and given order number is : ' + taskTemp.BMCServiceDesk__taskDescription__c);                                
				   taskCloseFlag = false ;   	                   
            }
            else if(taskTemp.wilReopen__c == true && taskTemp.BMCServiceDesk__templateOrder__c == orderNumber && taskTemp.BMCServiceDesk__Status_ID__c == 'CLOSED' ){
                StatusUpdate.updateStatus(taskTemp.Name);
                taskCloseFlag = false ;   	                
            }
        }
        
        if(taskCloseFlag){
            System.debug('All the task with template order ' + orderNumber + ' are closed ');
            
            StatusUpdate.reOpenWaitingTasks(orderNumber+1,releaseName); 		// Open all the task with given order number if will reopen is true.
        }
        System.debug('ending reOpenWaitingTask()');
    }
    
    public static String getTaskNumber(String taskId){
        BMCServiceDesk__Task__c task =[Select Name,BMCServiceDesk__taskDescription__c from BMCServiceDesk__Task__c t where t.id = :taskId] ;
        String taskName = task.Name ;
        return taskName ;       
    }
    
    public static String getReleaseName(String taskName){
        BMCServiceDesk__Task__c task =[Select Name, BMCServiceDesk__FKRelease__r.Name , BMCServiceDesk__templateOrder__c,BMCServiceDesk__taskDescription__c from BMCServiceDesk__Task__c t where t.Name = :taskName] ;
        String releaseName = task.BMCServiceDesk__FKRelease__r.Name ;
        return releaseName ;
    }
    
    public static Integer getTaskOrderNumber(String taskName){
        BMCServiceDesk__Task__c task =[Select Name, BMCServiceDesk__FKRelease__r.Name , BMCServiceDesk__templateOrder__c,BMCServiceDesk__taskDescription__c from BMCServiceDesk__Task__c t where t.Name = :taskName] ;
        Integer orderNumber = Integer.valueOf(task.BMCServiceDesk__templateOrder__c) ;    
        return orderNumber ;
       
    }
    
    public static String getTaskDescription(String taskName){
        BMCServiceDesk__Task__c task =[Select Name, BMCServiceDesk__FKRelease__r.Name , BMCServiceDesk__templateOrder__c,BMCServiceDesk__taskDescription__c from BMCServiceDesk__Task__c t where t.Name = :taskName] ;
        String taskDesc = task.BMCServiceDesk__taskDescription__c ;        
        return taskDesc ;
        
    }
    
}