@isTest(SeeAllData=true)
public class Test_Rel_Misc {
    
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
    BMCServiceDesk__templateOrder__c = 1,     
    wilReopen__c = true,
    BMCServiceDesk__FKStatus__c = closedID    
        
	) ;
    taskList.add(ta1);
        
    
	insert taskList;
    BMCServiceDesk__Task__c t = [select name from BMCServiceDesk__Task__c where id = :taskList[0].id];    
        
	Test.startTest();
        ReleaseFlow.reOpenWaitingTask(t.name,1);
        ReleaseFlow.getTaskOrderNumber(t.name);
        ReleaseFlow.getTaskDescription(t.name);
        
    Test.stopTest();    
//System.debug('Task Creted '  + ta.id);
        
    }

}