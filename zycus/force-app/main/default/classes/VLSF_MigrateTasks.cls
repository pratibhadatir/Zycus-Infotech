public class VLSF_MigrateTasks implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator([Select Id, VLSF_Link_Incident__c from Case
                                         Order by CreatedDate DESC]);
    }
    
    public void execute(Database.BatchableContext BC, List<Case> scope){
        try{
            List<Migration_Field_Mapping__mdt> fieldMapping = [SELECT MasterLabel, QualifiedApiName, Field_Mapping__c, Salesforce_Field__c, BMC_Field__c
                                                               FROM Migration_Field_Mapping__mdt];
            Map<Id, Case> caseIncidentMap = new Map<Id, Case>();
            For(Case cases:scope){
                caseIncidentMap.put(cases.VLSF_Link_Incident__c, cases);
            }
            List<Task> tasksToInsert = new List<Task>();
            List<EmailMessage> emailsToInsert = new List<EmailMessage>();
            List<VLSF_Task_Historical_Data__c> taskHistoricalDataList = new List<VLSF_Task_Historical_Data__c>();
            List<ContentVersion> contentVersionsToInsert = new List<ContentVersion>();
            List<BMCServiceDesk__IncidentHistory__c> IncidentHistory = [SELECT Id, BMCServiceDesk__Action_Duration__c, BMCServiceDesk__duration__c, BMCServiceDesk__date__c, BMCServiceDesk__note__c, BMCServiceDesk__actionId__c, BMCServiceDesk__userId__c, BMCServiceDesk__Client_Contact__c, BMCServiceDesk__Client_User__c, BMCServiceDesk__description__c, BMCServiceDesk__EmailConversationData__c, BMCServiceDesk__FKAction__c, BMCServiceDesk__FKAction__r.Name, BMCServiceDesk__FKAction__r.BMCServiceDesk__Abbreviation__c, BMCServiceDesk__FKIncident__c
                                                                        from BMCServiceDesk__IncidentHistory__c
                                                                        Where BMCServiceDesk__FKIncident__c = :caseIncidentMap.keySet()];
            List<BMCServiceDesk__Task__c> taskHistoryData = [SELECT Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, ConnectionReceivedId, ConnectionSentId, BMCServiceDesk__ACDeviceID__c, BMCServiceDesk__ACExecute__c, BMCServiceDesk__ACOpRuleID__c, BMCServiceDesk__ACOpRuleStatusDescription__c, BMCServiceDesk__ACOpRuleStatus__c, BMCServiceDesk__ACRequiresApproval__c, BMCServiceDesk__Additional_email_information__c, BMCServiceDesk__BLANK__c, BMCServiceDesk__Category_ID__c, BMCServiceDesk__Client_Account__c, BMCServiceDesk__Client_First_Name__c, BMCServiceDesk__Client_ID__c, BMCServiceDesk__Client_Last_Name__c, BMCServiceDesk__Client_Name__c, BMCServiceDesk__Client_Type__c, BMCServiceDesk__Closed_By__c, BMCServiceDesk__Compliant__c, BMCServiceDesk__Dummy_Update__c, BMCServiceDesk__ExistsInManifest__c, BMCServiceDesk__FKCategory__c, BMCServiceDesk__FKChange__c, BMCServiceDesk__FKClient__c, BMCServiceDesk__FKClosedBy__c, BMCServiceDesk__FKContact__c, BMCServiceDesk__FKImpact__c, BMCServiceDesk__FKIncident__c, BMCServiceDesk__FKLead__c, BMCServiceDesk__FKOpenBy__c, BMCServiceDesk__FKPriority__c, BMCServiceDesk__FKProblem__c, BMCServiceDesk__FKRelease__c, BMCServiceDesk__FKStatus__c, BMCServiceDesk__FKTemplate__c, BMCServiceDesk__FKUrgency__c, BMCServiceDesk__Impact_ID__c, BMCServiceDesk__Launch_console__c, BMCServiceDesk__Opened_DateTime__c, BMCServiceDesk__Priority_ID__c, BMCServiceDesk__Recurrence__c, BMCServiceDesk__RecurringParentRecordId__c, BMCServiceDesk__Scheduled_End_Date__c, BMCServiceDesk__Scheduled_Start_Date__c, BMCServiceDesk__Service_Request_Process__c, BMCServiceDesk__ShowDueDateDialog__c, BMCServiceDesk__Status_ID__c, BMCServiceDesk__Task_console_detail_link__c, BMCServiceDesk__TemplateAlreadyApplied__c, BMCServiceDesk__TemplateName__c, BMCServiceDesk__Urgency_ID__c, BMCServiceDesk__busAssessment__c, BMCServiceDesk__closeDateTime__c, BMCServiceDesk__closedProfile__c, BMCServiceDesk__comments__c, BMCServiceDesk__completedDate__c, BMCServiceDesk__contactType__c, BMCServiceDesk__costEstimate__c, BMCServiceDesk__createdOn__c, BMCServiceDesk__decision__c, BMCServiceDesk__dueDateTime__c, BMCServiceDesk__duration__c, BMCServiceDesk__eMailOriginator__c, BMCServiceDesk__endDate__c, BMCServiceDesk__inactive__c, BMCServiceDesk__isReopened__c, BMCServiceDesk__note__c, BMCServiceDesk__openDateTime__c, BMCServiceDesk__openedProfile__c, BMCServiceDesk__phone__c, BMCServiceDesk__processTemplateOrder__c, BMCServiceDesk__queueName__c, BMCServiceDesk__recommendations__c, BMCServiceDesk__recommendedFixDateTime__c, BMCServiceDesk__resourceDescription__c, BMCServiceDesk__responseDateTime__c, BMCServiceDesk__shortDescription__c, BMCServiceDesk__startDate__c, BMCServiceDesk__state__c, BMCServiceDesk__taskDescription__c, BMCServiceDesk__taskResolution__c, BMCServiceDesk__taskType__c, BMCServiceDesk__techAssessment__c, BMCServiceDesk__templateOrder__c, BMCServiceDesk__timeSpent__c, BMCServiceDesk__Total_Duration__c, Comment_box__c, AS_Documentation_Status__c, Additional_Email_id__c, CMDB_Status_updated_Demo__c, CMDB_Status_updated__c, Comment_Box1__c, Comment_Box2__c, DBA_Documentation_Status__c, DS_Documentation_Status__c, Date_Release_to_RM__c, Date_of_Release_to_App_Support__c, Date_of_Release_to_UAT__c, Date_of_release_to_GO__c, Deliverables_Location__c, Deployed_on_Demo_Demo__c, Deployed_on_Demo__c, Deployed_on_Production_Demo__c, Deployed_on_Production__c, Deployed_on_Staging_Demo__c, Deployed_on_Staging__c, Deployment_Status_Demo__c, Deployment_Status__c, Description_of_Release__c, Development_Status__c, ETA_PCS__c, ETA_UAT__c, ETA_deployment_on_Prod__c, ETA_of_completing_UAT_PCS__c, ETA_to_RM__c, Exception_Comments__c, Exception_Count__c, Expected_Demo_time__c, External_Training_conducted__c, IT_Documentation_Status__c, Internal_Training_conducted__c, Issue_escaped__c, L2_Documentation_Status__c, Location_of_Release_Deliverables__c, Location_of_UAT_deliverables__c, Patch_count__c, Post_upgrade_Notification_Status__c, Pre_upgrade_Notification_Status__c, Priority_Text_Task__c, Product__c, RC_Count__c, RM_Testing_Status__c, Rejected_On_Demo_Demo__c, Rejected_On_Prod_Demo__c, Rejected_on_Demo__c, Rejected_on_Prod__c, Rejected_on_Staging_Demo__c, Rejected_on_Staging__c, Rejection_Criteria_Demo__c, Rejection_Criteria__c, Release_version__c, Subject__c, TS_Documentation_Status__c, Task_Reopen_Count__c, Tech_Support_release_certified__c, Training_conducted1__c, Training_conducted__c, UAT_GDT_Completion_Date__c, UAT_GO_Completion_Date__c, UAT_Required__c, UAT_Status__c, approvalFlag__c, isLocked__c, isSetNewQueueName__c, newQueueName__c, wilReopen__c, Failed_Due_to__c
                                                             FROM BMCServiceDesk__Task__c
                                                             Where BMCServiceDesk__FKIncident__c = :caseIncidentMap.keySet()];
            for (BMCServiceDesk__IncidentHistory__c history : IncidentHistory){
                if (history.BMCServiceDesk__FKAction__r.Name.equalsIgnoreCase('Email Received') || history.BMCServiceDesk__FKAction__r.Name.equalsIgnoreCase('Email Sent')){
                    // Create EmailMessage for email actions
                    EmailMessage email = new EmailMessage();
                    email.ParentId = caseIncidentMap.get(history.BMCServiceDesk__FKIncident__c).Id;
                    email.Subject = history.BMCServiceDesk__description__c;
                    email.TextBody = history.BMCServiceDesk__note__c;
                    email.VLSF_Action__c = history.BMCServiceDesk__FKAction__c;
                    email.FromName = history.BMCServiceDesk__userId__c;
                    email.VLSF_Incident__c = history.BMCServiceDesk__FKIncident__c;
                    email.VLSF_Incident_History__c = history.Id;
                    email.VLSF_Duration__c = history.BMCServiceDesk__duration__c;
                    email.MessageDate = history.BMCServiceDesk__date__c;
                    emailsToInsert.add(email);
                } else if (history.BMCServiceDesk__FKAction__r.Name.equalsIgnoreCase('Notes') || history.BMCServiceDesk__FKAction__r.Name.equalsIgnoreCase('Client Note')){
                    ContentVersion contentVersion = new ContentVersion();
                    contentVersion.Title = history.BMCServiceDesk__Description__c;
                    contentVersion.PathOnClient = 'comment_' + DateTime.now().getTime() + '.snote';
                    contentVersion.VersionData = Blob.valueOf('Action ID: ' + history.BMCServiceDesk__FKAction__c + '\n' + 
                                                              'Description: ' + history.BMCServiceDesk__description__c + '\n' + 
                                                              'Note: ' + history.BMCServiceDesk__note__c + '\n' + 
                                                              'Duration: ' + history.BMCServiceDesk__duration__c + '\n' + 
                                                              'Date: ' + history.BMCServiceDesk__date__c + '\n' + 
                                                              'User ID: ' + history.BMCServiceDesk__userId__c + '\n' + 
                                                              'Incident ID: ' + history.BMCServiceDesk__FKIncident__c);
                    contentVersion.Origin = 'H';
                    contentVersion.FirstPublishLocationId = caseIncidentMap.get(history.BMCServiceDesk__FKIncident__c).Id;
                    contentVersionsToInsert.add(contentVersion);
                }
                
            }
            
            for (BMCServiceDesk__Task__c taskhistory : taskHistoryData){
                // Create Task for non-email actions
                Task task = new Task();
                task.WhatId = caseIncidentMap.get(taskhistory.BMCServiceDesk__FKIncident__c).Id;
                task.VLSF_Template__c = taskhistory.BMCServiceDesk__FKTemplate__c;
                task.VLSF_Product__c = taskhistory.Product__c;
                task.Subject = taskhistory.Subject__c;
                task.Description = taskhistory.BMCServiceDesk__taskDescription__c;
                task.VLSF_Impact__c = taskhistory.BMCServiceDesk__Impact_ID__c;
                //task.VLSF_Urgency__c=taskhistory.BMCServiceDesk__Urgency_ID__c;
                // task.VLSF_Priority__c=taskhistory.BMCServiceDesk__Priority_ID__c;
                task.Status = taskhistory.BMCServiceDesk__Status_ID__c;
                task.OwnerId = taskhistory.OwnerId;
                task.VLSF_Resolution__c = taskhistory.BMCServiceDesk__taskResolution__c;
                task.VLSF_Closed_By__c = taskhistory.BMCServiceDesk__Closed_By__c;
                tasksToInsert.add(task);
                
                for (Migration_Field_Mapping__mdt mapping : fieldMapping){
                    // Map Incident fields to Case fields based on custom metadata
                    VLSF_Task_Historical_Data__c taskHis = new VLSF_Task_Historical_Data__c();
                    if (mapping.Field_Mapping__c == 'Task'){
                        taskHis.put(mapping.Salesforce_Field__c, String.valueOf(taskhistory.get(mapping.BMC_Field__c)));
                    }
                    taskHistoricalDataList.add(taskHis);
                }
            }
            
            if (!taskHistoricalDataList.isEmpty()){
                insert taskHistoricalDataList;
            }
            
            if (!contentVersionsToInsert.isEmpty()){
                insert contentVersionsToInsert;
            }
            
            if (!tasksToInsert.isEmpty()){
                insert tasksToInsert;
            }
            
            if (!emailsToInsert.isEmpty()){
                insert emailsToInsert;
            }
        } catch (Exception ex){
            Set<Id> caseIDs = new Set<Id>();
            If (!scope.isEmpty()){
                for (Case ca : scope){
                    caseIDs.add(ca.Id);
                }
            }
            String scopeString = JSON.serializePretty(caseIDs);
            VLSF_ExceptionLog.exceptionLog(ex, scopeString);
        }
    }
    
    public void finish(Database.BatchableContext BC){
        // No post-processing needed
    }
}