public class Failure_Task_Creation {
   
    
    public static void createTask(ID releaseID,Decimal curr_orderNumber){
        
        System.debug('CreateTask() started');
        	BMCServiceDesk__SYSTemplate__c res = [select id from BMCServiceDesk__SYSTemplate__c where name = 'RM to review failure'];
        	String templId = res.id ;
            List<BMCServiceDesk__Task__c> taskList = new List<BMCServiceDesk__Task__c>{};    
            BMCServiceDesk__Task__c ta1 = new BMCServiceDesk__Task__c(
            BMCServiceDesk__FKRelease__c = releaseID,
            //skipTask_Field_Population__c = true,
            legal_RM_Failure_Task__c =  true,
            BMCServiceDesk__templateOrder__c = curr_orderNumber,
            BMCServiceDesk__FKTemplate__c =templId
            ) ;
            taskList.add(ta1);
        	insert taskList;
        System.debug('CreateTask() ends');
    }
    
    	
}