@isTest(SeeAllData=true)
public class Test_SetOwnerName_P3 {
    
    public static testmethod void testing_Releaese_Flow(){
        
   //  String releaseID = TestDataFactory.createOneRelease();
     String urgencyID = TestDataFactory.getIdForUrgency();   
     String Impactid =  TestDataFactory.getIdForImpact() ; 
        
        
    List<BMCServiceDesk__Task__c> taskList = new List<BMCServiceDesk__Task__c>{};    
   
   
              
       BMCServiceDesk__Task__c ta12 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Update application configuration CMDB',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta12);   
        
             
       BMCServiceDesk__Task__c ta13 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Update application CMDB',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta13);   
        
             
       BMCServiceDesk__Task__c ta14 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Update database CMDB',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta14);   
        
              
       BMCServiceDesk__Task__c ta15 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Update Infra CMDB',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta15);     
    
           BMCServiceDesk__Task__c ta16 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='PEG MIS to start measuing the adoption of the feature in 30-60-90 ',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta16);     
        
	       BMCServiceDesk__Task__c ta17 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Installation on pre-prod',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta17);     
        
            BMCServiceDesk__Task__c ta18 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Test the release on Sandbox',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta18);  

    BMCServiceDesk__Task__c ta19 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Provide upgrade plan to release group',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta19);            

        


	insert taskList;
	Test.startTest();
       // ReleaseFlow.reopenTasksBasedOnFailure(taskList[6].id,'RM');
    Test.stopTest();    
//System.debug('Task Creted '  + ta.id);
        
    }

}