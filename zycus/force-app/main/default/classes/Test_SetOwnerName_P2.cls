@isTest(SeeAllData=true)
public class Test_SetOwnerName_P2 {
    
    public static testmethod void testing_Releaese_Flow(){
        
   //  String releaseID = TestDataFactory.createOneRelease();
     String urgencyID = TestDataFactory.getIdForUrgency();   
     String Impactid =  TestDataFactory.getIdForImpact() ; 
        
        
    List<BMCServiceDesk__Task__c> taskList = new List<BMCServiceDesk__Task__c>{};    
   
   
              
       BMCServiceDesk__Task__c ta12 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Validate the App-Management deliverables',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta12);   
        
             
       BMCServiceDesk__Task__c ta13 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Validate the Demo-Support deliverables',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta13);   
        
             
       BMCServiceDesk__Task__c ta14 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Validate the GO-DBA deliverables',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta14);   
        
              
       BMCServiceDesk__Task__c ta15 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Validate the GO-IT deliverables',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta15);     
    
           BMCServiceDesk__Task__c ta16 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Validate the Tech Support deliverables',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta16);     
        
	       BMCServiceDesk__Task__c ta17 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Certification of Support teams, Consultants and Project teams',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta17);     
        

               BMCServiceDesk__Task__c ta18 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Put up Pre - upgrade Notification',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta18);     
        

               BMCServiceDesk__Task__c ta19 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Deploy the release on Demo',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta19);     
        

               BMCServiceDesk__Task__c ta20 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Deploy the release on Prod',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta20);     
        

               BMCServiceDesk__Task__c ta21 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Post Upgrade Notification setup',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta21);     
        


	insert taskList;
	Test.startTest();
       // ReleaseFlow.reopenTasksBasedOnFailure(taskList[6].id,'RM');
    Test.stopTest();    
//System.debug('Task Creted '  + ta.id);
        
    }

}