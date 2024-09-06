@isTest(SeeAllData=true)
public class Test_Failure_Task_Creation {
    
    public static testmethod void testing_Releaese_Flow(){
        
     String releaseID = TestDataFactory.createOneRelease();
     String urgencyID = TestDataFactory.getIdForUrgency();   
     String Impactid =  TestDataFactory.getIdForImpact() ; 
        
        
    List<BMCServiceDesk__Task__c> taskList = new List<BMCServiceDesk__Task__c>{};    
    BMCServiceDesk__Task__c ta1 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Ta1',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c =Impactid,
    BMCServiceDesk__FKRelease__c = releaseID,
    skipTask_Field_Population__c = true    
	) ;
    taskList.add(ta1);
  

	insert taskList;
	Test.startTest();
        Failure_Task_Creation.createTask(releaseID,1);
    Test.stopTest();    
//System.debug('Task Creted '  + ta.id);
        
    }

}