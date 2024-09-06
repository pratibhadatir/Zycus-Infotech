@isTest(SeeAllData=true)
public class Test_Status_Update_Reopen {
    
    public static testmethod void testing_Releaese_Flow(){
        
     String releaseID = TestDataFactory.createOneRelease();
     String urgencyID = TestDataFactory.getIdForUrgency();   
     String Impactid =  TestDataFactory.getIdForImpact() ; 
     String closedID = StatusUpdate.getIdForStatus('closed');
        
        
    List<BMCServiceDesk__Task__c> taskList = new List<BMCServiceDesk__Task__c>{};    
    BMCServiceDesk__Task__c ta1 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Ta1',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c =Impactid,
    BMCServiceDesk__FKRelease__c = releaseID,
    skipTask_Field_Population__c = true ,
    BMCServiceDesk__templateOrder__c = 2,     
    BMCServiceDesk__FKStatus__c = closedID    
        
	) ;
    taskList.add(ta1);
        
    
	insert taskList;
    BMCServiceDesk__Task__c t = [select name,BMCServiceDesk__FKRelease__r.name from BMCServiceDesk__Task__c where id = :taskList[0].id];   
     
  	 
        
    //System.debug('Class Test_Status : Incident name    ' + inc.name );    
        
	Test.startTest();
        StatusUpdate.setWillReOpen(t.name);
        StatusUpdate.reOpenWaitingTasks(2,t.BMCServiceDesk__FKRelease__r.name);
    Test.stopTest();    
//System.debug('Task Creted '  + ta.id);
        
    }

}