public class Set_Task_Fields_Captured_In_Release {
    
    public static void setFields(String taskNumber){
         System.debug('setFields() starts');
         BMCServiceDesk__Task__c  task   = [Select BMCServiceDesk__FKRelease__c,skipTask_Field_Population__c,BMCServiceDesk__templateOrder__c From BMCServiceDesk__Task__c where name =:taskNumber limit 1 ];
         System.debug('B : ' + task.BMCServiceDesk__FKRelease__c);
        if(task.BMCServiceDesk__FKRelease__c!=null&&task.skipTask_Field_Population__c!=TRUE)	{
             BMCServiceDesk__Release__c  release   = [Select r.Name, (Select Name, BMCServiceDesk__Status_ID__c,BMCServiceDesk__templateOrder__c,BMCServiceDesk__taskDescription__c,
                                                  Internal_Training_conducted__c,
                                                  External_Training_conducted__c,
												  UAT_GDT_Completion_Date__c,
                                                  UAT_GO_Completion_Date__c,
                                                  Date_of_Release_to_UAT__c,
                                                  ETA_of_completing_UAT_PCS__c,
                                                  UAT_Status__c,
												  Date_of_release_to_GO__c,
                                                  Location_of_Release_Deliverables__c,
												  UAT_Required__c,
                                                  RM_Testing_Status__c,
                                                  Date_Release_to_RM__c,
                                                  Pre_upgrade_Notification_Status__c,
                                                  Comment_Box1__c,
                                                  Training_conducted1__c,
                                                  Post_upgrade_Notification_Status__c,
                                                  TS_Documentation_Status__c,
                                                  Tech_Support_release_certified__c,
                                                  ETA_to_RM__c,
                                                  ETA_deployment_on_Prod__c,
                                                  Description_of_Release__c,
                                                  ETA_PCS__c,
                                                  ETA_UAT__c,
                                                  Patch_count__c,
                                                  Release_version__c,
                                                  RC_Count__c,
                                                  Exception_Comments__c,
                                                  Exception_Count__c,
                                                  Training_conducted__c,
                                                  L2_Documentation_Status__c,
                                                  Comment_box__c,
                                                  Deliverables_Location__c,
                                                  Development_Status__c,
                                                  Location_of_UAT_deliverables__c,
                                                  DBA_Documentation_Status__c,
                                                  Comment_Box2__c,
                                                  IT_Documentation_Status__c,
                                                  Deployed_on_Demo_Demo__c,
                                                  Deployed_on_Production_Demo__c,
                                                  Deployment_Status_Demo__c,
                                                  DS_Documentation_Status__c,                
                                                  Rejected_On_Demo_Demo__c,
                                                  Deployed_on_Staging_Demo__c,
                                                  Rejected_On_Prod_Demo__c,
                                                  Rejected_on_Staging_Demo__c,                
                                                  Rejection_Criteria_Demo__c,
                                                  CMDB_Status_updated_Demo__c,
                								  Date_of_Release_to_App_Support__c,
                                                  Deployed_on_Demo__c,
                                                   Deployed_on_Staging__c,
                                                   Deployed_on_Production__c,
                                                   Deployment_Status__c,
                                                    CMDB_Status_updated__c,
                                                   Rejection_Criteria__c,
                                                    Rejected_on_Demo__c,
                                                    Rejected_on_Staging__c,
                                                    Rejected_on_Prod__c,
                                                    AS_Documentation_Status__c              
                                                  From BMCServiceDesk__Tasks__r t  where t.BMCServiceDesk__templateOrder__c =:(task.BMCServiceDesk__templateOrder__c-1)  ORDER BY Name ) 
                                    			  From BMCServiceDesk__Release__c r where id =:task.BMCServiceDesk__FKRelease__c ];
        System.debug('C : '  + release.BMCServiceDesk__Tasks__r);
            
        for(BMCServiceDesk__Task__c taskTemp : release.BMCServiceDesk__Tasks__r){
           System.debug('execution order  number  of task ' + taskTemp.Name + ' is ' 
                        + taskTemp.BMCServiceDesk__templateOrder__c + ' and status : ' 
                        + taskTemp.BMCServiceDesk__Status_ID__c  + ' description : '
                        +taskTemp.BMCServiceDesk__taskDescription__c 
                        +taskTemp.L2_Documentation_Status__c);  
							
               if(taskTemp.BMCServiceDesk__templateOrder__c == (task.BMCServiceDesk__templateOrder__c-1) ){ // will open all the task with template order 1.
                   if(taskTemp.Internal_Training_conducted__c!=null){task.Internal_Training_conducted__c = taskTemp.Internal_Training_conducted__c;}
                   if(taskTemp.External_Training_conducted__c!=null){task.External_Training_conducted__c =  taskTemp.External_Training_conducted__c;}
                   if(taskTemp.UAT_GDT_Completion_Date__c!=null){task.UAT_GDT_Completion_Date__c = taskTemp.UAT_GDT_Completion_Date__c;}
                   if(taskTemp.UAT_GO_Completion_Date__c!=null){task.UAT_GO_Completion_Date__c = taskTemp.UAT_GO_Completion_Date__c;}
                   if(taskTemp.Date_of_Release_to_UAT__c!=null){task.Date_of_Release_to_UAT__c = taskTemp.Date_of_Release_to_UAT__c;}
                   if(taskTemp.ETA_of_completing_UAT_PCS__c!=null){task.ETA_of_completing_UAT_PCS__c = taskTemp.ETA_of_completing_UAT_PCS__c;}
                   if(taskTemp.UAT_Status__c!=null){task.UAT_Status__c = taskTemp.UAT_Status__c;}
                   if(taskTemp.Date_of_release_to_GO__c!=null){task.Date_of_release_to_GO__c = taskTemp.Date_of_release_to_GO__c;}
                   if(taskTemp.Location_of_Release_Deliverables__c!=null){task.Location_of_Release_Deliverables__c = taskTemp.Location_of_Release_Deliverables__c;}
                   if(taskTemp.UAT_Required__c!=null){task.UAT_Required__c = taskTemp.UAT_Required__c;}
                   if(taskTemp.RM_Testing_Status__c!=null){task.RM_Testing_Status__c = taskTemp.RM_Testing_Status__c;}
                   if(taskTemp.Date_Release_to_RM__c!=null){task.Date_Release_to_RM__c = taskTemp.Date_Release_to_RM__c;}
                   if(taskTemp.Pre_upgrade_Notification_Status__c!=null){task.Pre_upgrade_Notification_Status__c = taskTemp.Pre_upgrade_Notification_Status__c;}
                   if(taskTemp.Comment_Box1__c!=null){task.Comment_Box1__c = taskTemp.Comment_Box1__c;}
                   if(taskTemp.Training_conducted1__c!=null){task.Training_conducted1__c = taskTemp.Training_conducted1__c;}
                   if(taskTemp.Post_upgrade_Notification_Status__c!=null){task.Post_upgrade_Notification_Status__c = taskTemp.Post_upgrade_Notification_Status__c;}
                   if(taskTemp.TS_Documentation_Status__c!=null){task.TS_Documentation_Status__c = taskTemp.TS_Documentation_Status__c;}
                   if(taskTemp.Tech_Support_release_certified__c!=null){task.Tech_Support_release_certified__c = taskTemp.Tech_Support_release_certified__c;}
                   if(taskTemp.ETA_to_RM__c!=null){task.ETA_to_RM__c = taskTemp.ETA_to_RM__c;  }
                   if(taskTemp.ETA_deployment_on_Prod__c!=null){task.ETA_deployment_on_Prod__c = taskTemp.ETA_deployment_on_Prod__c; }
                   if(taskTemp.Description_of_Release__c!=null){task.Description_of_Release__c = taskTemp.Description_of_Release__c;}
                   if(taskTemp.ETA_PCS__c!=null){task.ETA_PCS__c = taskTemp.ETA_PCS__c; }
                   if(taskTemp.ETA_UAT__c!=null){task.ETA_UAT__c = taskTemp.ETA_UAT__c;}
                   if(taskTemp.Patch_count__c!=null){task.Patch_count__c = taskTemp.Patch_count__c;}
                   if(taskTemp.Release_version__c!=null){task.Release_version__c = taskTemp.Release_version__c;}
                   if(taskTemp.RC_Count__c!=null){task.RC_Count__c = taskTemp.RC_Count__c;}
                   if(taskTemp.Exception_Comments__c!=null){task.Exception_Comments__c = taskTemp.Exception_Comments__c;}
                   if(taskTemp.Exception_Count__c!=null){task.Exception_Count__c = taskTemp.Exception_Count__c;}
                   if(taskTemp.Training_conducted__c!=null){task.Training_conducted__c = taskTemp.Training_conducted__c;}
                   if(taskTemp.L2_Documentation_Status__c!=null){task.L2_Documentation_Status__c = taskTemp.L2_Documentation_Status__c;}
                   if(taskTemp.Comment_box__c!=null){task.Comment_box__c = taskTemp.Comment_box__c;}
                   if(taskTemp.Deliverables_Location__c!=null){task.Deliverables_Location__c = taskTemp.Deliverables_Location__c;}
                   if(taskTemp.Development_Status__c!=null){task.Development_Status__c = taskTemp.Development_Status__c;}
                   if(taskTemp.Location_of_UAT_deliverables__c!=null){task.Location_of_UAT_deliverables__c = taskTemp.Location_of_UAT_deliverables__c;}
                   if(taskTemp.DBA_Documentation_Status__c!=null){task.DBA_Documentation_Status__c = taskTemp.DBA_Documentation_Status__c;}
                   if(taskTemp.Comment_Box2__c!=null){task.Comment_Box2__c = taskTemp.Comment_Box2__c;}
                   if(taskTemp.IT_Documentation_Status__c!=null){task.IT_Documentation_Status__c = taskTemp.IT_Documentation_Status__c; }
                   if(taskTemp.Deployed_on_Demo_Demo__c!=null){task.Deployed_on_Demo_Demo__c = taskTemp.Deployed_on_Demo_Demo__c;}
                   if(taskTemp.Deployed_on_Production_Demo__c!=null){task.Deployed_on_Production_Demo__c = taskTemp.Deployed_on_Production_Demo__c;}
                   if(taskTemp.Deployment_Status_Demo__c!=null){task.Deployment_Status_Demo__c = taskTemp.Deployment_Status_Demo__c;}
                   if(taskTemp.DS_Documentation_Status__c!=null){task.DS_Documentation_Status__c = taskTemp.DS_Documentation_Status__c;}
                   if(taskTemp.Rejected_On_Demo_Demo__c!=null){task.Rejected_On_Demo_Demo__c = taskTemp.Rejected_On_Demo_Demo__c;}
                   if(taskTemp.Deployed_on_Staging_Demo__c!=null){task.Deployed_on_Staging_Demo__c = taskTemp.Deployed_on_Staging_Demo__c;}
                   if(taskTemp.Rejected_On_Prod_Demo__c!=null){task.Rejected_On_Prod_Demo__c = taskTemp.Rejected_On_Prod_Demo__c;}
                   if(taskTemp.Rejected_on_Staging_Demo__c!=null){task.Rejected_on_Staging_Demo__c = taskTemp.Rejected_on_Staging_Demo__c;}
                   if(taskTemp.Rejection_Criteria_Demo__c!=null){task.Rejection_Criteria_Demo__c = taskTemp.Rejection_Criteria_Demo__c;}
                   if(taskTemp.CMDB_Status_updated_Demo__c!=null){task.CMDB_Status_updated_Demo__c = taskTemp.CMDB_Status_updated_Demo__c;}
                   if(taskTemp.Date_of_Release_to_App_Support__c!=null){task.Date_of_Release_to_App_Support__c = taskTemp.Date_of_Release_to_App_Support__c;}
                   if(taskTemp.Deployed_on_Demo__c!=null){task.Deployed_on_Demo__c = taskTemp.Deployed_on_Demo__c;}
                   if(taskTemp.Deployed_on_Staging__c!=null){task.Deployed_on_Staging__c = taskTemp.Deployed_on_Staging__c;}
                   if(taskTemp.Deployed_on_Production__c!=null){task.Deployed_on_Production__c = taskTemp.Deployed_on_Production__c;}
                   if(taskTemp.Deployment_Status__c!=null){task.Deployment_Status__c = taskTemp.Deployment_Status__c;}
                   if(taskTemp.CMDB_Status_updated__c!=null){task.CMDB_Status_updated__c = taskTemp.CMDB_Status_updated__c;}
                   if(taskTemp.Rejection_Criteria__c!=null){task.Rejection_Criteria__c = taskTemp.Rejection_Criteria__c;}
                   if(taskTemp.Rejected_on_Demo__c!=null){task.Rejected_on_Demo__c = taskTemp.Rejected_on_Demo__c;}
                   if(taskTemp.Rejected_on_Staging__c!=null){task.Rejected_on_Staging__c = taskTemp.Rejected_on_Staging__c;}
                   if(taskTemp.Rejected_on_Prod__c!=null){task.Rejected_on_Prod__c = taskTemp.Rejected_on_Prod__c;}
                   if(taskTemp.AS_Documentation_Status__c!=null){task.AS_Documentation_Status__c = taskTemp.AS_Documentation_Status__c;}
                  
                   
                   
               }
           
              
         }
        
        
             
       if(task.BMCServiceDesk__templateOrder__c != 1){
           		 try{
                    //TriggerFlag.setUpdateFlag(); //To prevent the update trigger recursion.   
                    update task ;   
                }
                Catch(Exception e){
                    System.debug('Getting error' + e.getMessage());     
                } 
       }
        }
         //Loop Through the task which has template 
         //order one less than the current task and 
         //populate the current task fields using it.
        
                
        System.debug('setFields() ends');
    }
 
}