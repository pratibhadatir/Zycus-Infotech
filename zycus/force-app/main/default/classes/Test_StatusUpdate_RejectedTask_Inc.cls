@isTest(SeeAllData=true)
public class Test_StatusUpdate_RejectedTask_Inc {
    
    public static testmethod void testing_Releaese_Flow(){
  
     TestDataFactory.createOneCategory();
        
        String var_id = TestDataFactory.createOneIncident();
        BMCServiceDesk__Incident__c inc = [select name from BMCServiceDesk__Incident__c where id = :var_id];   
  	       
	Test.startTest();
       // StatusUpdate.updateStatusAsRejectedForTask(t.name);
      StatusUpdate.updateStatusAsRejected(inc.name);
         
    Test.stopTest();    
//System.debug('Task Creted '  + ta.id);
        
    }

}