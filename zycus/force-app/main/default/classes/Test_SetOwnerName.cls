@isTest(SeeAllData=true)
public class Test_SetOwnerName {
    
    public static testmethod void testing_Releaese_Flow(){
        
   //  String releaseID = TestDataFactory.createOneRelease();
     String urgencyID = TestDataFactory.getIdForUrgency();   
     String Impactid =  TestDataFactory.getIdForImpact() ; 
        
        
    List<BMCServiceDesk__Task__c> taskList = new List<BMCServiceDesk__Task__c>{};    
    BMCServiceDesk__Task__c ta1 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Set up CAB meeting',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c =Impactid,
    skipTask_Field_Population__c = true    
	) ;
    taskList.add(ta1);
        
    BMCServiceDesk__Task__c ta2 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='PEG MIS to start measuing the adoption of the feature in 30-60-90',
    BMCServiceDesk__FKUrgency__c =urgencyID,
   	BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 2    

								) ;
    taskList.add(ta2); 
        
        
    BMCServiceDesk__Task__c ta3 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Project team to discuss the Release in MBR\'s along with a  case study about the impact of the release',
    BMCServiceDesk__FKUrgency__c =urgencyID,
	BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
	BMCServiceDesk__templateOrder__c = 3
	) ;
    taskList.add(ta3); 
        
    BMCServiceDesk__Task__c ta4 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Deploy the release on sandbox',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid, 
	
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 4    
								) ;
    taskList.add(ta4); 
        
    BMCServiceDesk__Task__c ta5 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Release specific configuration on sandbox',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 5    

								) ;
    taskList.add(ta5); 
        
  	BMCServiceDesk__Task__c ta6 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Train the SPOCs,University,Support team',
 	BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
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
    BMCServiceDesk__taskDescription__c='Perform UAT',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta7);    
     
      BMCServiceDesk__Task__c ta8 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Fit for release',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 5    

								) ;
    taskList.add(ta8); 
        
  	BMCServiceDesk__Task__c ta9 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='RM to review the failure',
 	BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 6,
    UAT_GDT_Completion_Date__c = System.now(),
    UAT_Status__c = 'pass',
    Date_of_Release_to_UAT__c = System.now(),
    ETA_of_completing_UAT_PCS__c = System.now(),
    UAT_GO_Completion_Date__c = System.now()    

								) ;
    taskList.add(ta9);     
        
       BMCServiceDesk__Task__c ta10 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='University to start customer training',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta10); 
        
             
       BMCServiceDesk__Task__c ta11 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='Validate the App-Support deliverables',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 7    

								) ;  
     taskList.add(ta11);   
     /*   
              
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
        

*/
	insert taskList;
	Test.startTest();
       // ReleaseFlow.reopenTasksBasedOnFailure(taskList[6].id,'RM');
    Test.stopTest();    
//System.debug('Task Creted '  + ta.id);
        
    }

}