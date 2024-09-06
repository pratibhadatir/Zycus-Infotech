@isTest(SeeAllData=true)
public class Test_Rel_Flow_Dev {
    
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
        
    BMCServiceDesk__Task__c ta2 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='test',
    BMCServiceDesk__FKUrgency__c =urgencyID,
   	BMCServiceDesk__FKImpact__c = Impactid,
    BMCServiceDesk__FKRelease__c = releaseID,
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 2    

								) ;
    taskList.add(ta2); 
        
        
    BMCServiceDesk__Task__c ta3 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Test',
    BMCServiceDesk__FKUrgency__c =urgencyID,
	BMCServiceDesk__FKImpact__c = Impactid,
    BMCServiceDesk__FKRelease__c = releaseID,
    skipTask_Field_Population__c = true,
	BMCServiceDesk__templateOrder__c = 3
	) ;
    taskList.add(ta3); 
        
    BMCServiceDesk__Task__c ta4 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Test',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid, 
	BMCServiceDesk__FKRelease__c = releaseID,
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 4    
								) ;
    taskList.add(ta4); 
        
    BMCServiceDesk__Task__c ta5 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Test',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    BMCServiceDesk__FKRelease__c = releaseID,
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 5    

								) ;
    taskList.add(ta5); 
        
  	BMCServiceDesk__Task__c ta6 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Perform UAT',
 	BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    BMCServiceDesk__FKRelease__c = releaseID,
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 6,
    UAT_GDT_Completion_Date__c = System.now(),
    UAT_Status__c = 'pass',
    Date_of_Release_to_UAT__c = System.now(),
    ETA_of_completing_UAT_PCS__c = System.now(),
    UAT_GO_Completion_Date__c = System.now()    

								) ;
    taskList.add(ta6);     
        
       BMCServiceDesk__Task__c ta7 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Test7',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    BMCServiceDesk__FKRelease__c = releaseID,
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta7);    
        

	insert taskList;
	Test.startTest();
        ReleaseFlow.reopenTasksBasedOnFailure(taskList[6].id,'Dev');
    Test.stopTest();    
//System.debug('Task Creted '  + ta.id);
        
    }

}