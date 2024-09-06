@isTest(SeeAllData=true)
public class Test_Set_Task_Fields_Cap_In_Rel {
    
    public static testmethod void testing_Releaese_Flow(){
        
     String releaseID = TestDataFactory.createOneRelease();
     String urgencyID = TestDataFactory.getIdForUrgency();   
     String Impactid =  TestDataFactory.getIdForImpact() ; 
        
        
    List<BMCServiceDesk__Task__c> taskList = new List<BMCServiceDesk__Task__c>{};    
   
   
              
    BMCServiceDesk__Task__c ta1 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='ta1',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    BMCServiceDesk__FKRelease__c = releaseID,
    skipTask_Field_Population__c = true,
    BMCServiceDesk__templateOrder__c = 2,        
    Internal_Training_conducted__c = 'Yes',
        External_Training_conducted__c = 'Yes',
        UAT_GDT_Completion_Date__c = System.now(),
        UAT_GO_Completion_Date__c=System.now(),
        Date_of_Release_to_UAT__c=System.now(),
        ETA_of_completing_UAT_PCS__c=System.now(),
        UAT_Status__c = 'Pass',
        Date_of_release_to_GO__c = System.now(),
        Location_of_Release_Deliverables__c = 'test',
        UAT_Required__c= false,
        RM_Testing_Status__c = 'Open',
        Date_Release_to_RM__c = System.now(),
        Pre_upgrade_Notification_Status__c = 'yes',
        Comment_Box1__c = 'test',
        Training_conducted1__c= 'Yes',
        Post_upgrade_Notification_Status__c = 'Yes',
        TS_Documentation_Status__c = 'Accepted',
        Tech_Support_release_certified__c = 'Yes',
        ETA_to_RM__c = System.now(),
        ETA_deployment_on_Prod__c = System.now(),
        Description_of_Release__c = 'Test',
        ETA_PCS__c = System.now(),
        ETA_UAT__c = System.now(),
        Patch_count__c = 1,
        Release_version__c = '1',
        RC_Count__c = '1',
        Exception_Comments__c = 'Test',
        Exception_Count__c = '1',
        Training_conducted__c = 'Yes',
        L2_Documentation_Status__c = 'Accepted',
        Comment_box__c = 'test',
        Deliverables_Location__c = 'Test',
        Development_Status__c = 'Open',
        Location_of_UAT_deliverables__c = 'Test',
        DBA_Documentation_Status__c = 'Accepted',
        Comment_Box2__c = 'test',
        IT_Documentation_Status__c = 'Accepted',
        Deployed_on_Demo_Demo__c = System.now(),
        Deployed_on_Production_Demo__c = System.now(),
        Deployment_Status_Demo__c = 'Opened',
        DS_Documentation_Status__c = 'Accepted',                
        Rejected_On_Demo_Demo__c = false,
        Deployed_on_Staging_Demo__c = System.now(),
        Rejected_On_Prod_Demo__c = false,
        Rejected_on_Staging_Demo__c = false,                
        Rejection_Criteria_Demo__c = 'test',
        CMDB_Status_updated_Demo__c = 'test',
        Date_of_Release_to_App_Support__c = System.now(),
        Deployed_on_Demo__c =System.now(),
        Deployed_on_Staging__c = System.now(),
        Deployed_on_Production__c = System.now(),
        Deployment_Status__c= 'opened',
        CMDB_Status_updated__c = 'yes',
        Rejection_Criteria__c = 'false',
        Rejected_on_Demo__c = false,
        Rejected_on_Staging__c = false,
        Rejected_on_Prod__c = false,
        AS_Documentation_Status__c = 'Accepted'      


								) ;  
     taskList.add(ta1);   
        
             
    BMCServiceDesk__Task__c ta2 = new BMCServiceDesk__Task__c(
    BMCServiceDesk__taskDescription__c='ta2',
    BMCServiceDesk__FKUrgency__c =urgencyID,
    BMCServiceDesk__FKImpact__c = Impactid,
    BMCServiceDesk__templateOrder__c = 3,
    BMCServiceDesk__FKRelease__c = releaseID    

								) ;  
     taskList.add(ta2);   
        
             

	insert taskList;
	Test.startTest();
       // ReleaseFlow.reopenTasksBasedOnFailure(taskList[6].id,'RM');
    Test.stopTest();    
//System.debug('Task Creted '  + ta.id);
        
    }

}