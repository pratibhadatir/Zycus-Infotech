public class VLSF_MigrateProblem implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        // Query to delete account records with name 'Test Account12'
        
         Migration_Field_Mapping__mdt fieldMapping = [SELECT MasterLabel, QualifiedApiName, VLSF_Calender_Year__c
                                                     FROM Migration_Field_Mapping__mdt 
                                                     Where MasterLabel like '%CALENDAR_YEAR%' LIMIT 1];
        Integer year = Integer.valueOf(fieldMapping.VLSF_Calender_Year__c);
        
        return Database.getQueryLocator([SELECT BMCServiceDesk__Additional_email_information__c, BMCServiceDesk__AllTaskCloseController__c, BMCServiceDesk__BLANK__c, BMCServiceDesk__Category__c, OwnerId, LastReferencedDate, LastViewedDate, BMCServiceDesk__Closed_Date_Time__c, BMCServiceDesk__ClosureCategory__c, BMCServiceDesk__Compliant__c, BMCServiceDesk__Due_Date_Time__c, BMCServiceDesk__FKBroadcast__c, BMCServiceDesk__FKCategory__c, BMCServiceDesk__FKClosed_By__c, BMCServiceDesk__FKImpact__c, BMCServiceDesk__FKPriority__c, BMCServiceDesk__FKStaff__c, BMCServiceDesk__FKStatus__c, BMCServiceDesk__FKUrgency__c, BMCServiceDesk__Impact__c, BMCServiceDesk__Inactive__c, BMCServiceDesk__Known_Error__c, BMCServiceDesk__Launch_Console__c, BMCServiceDesk__Open_Date_Time__c, BMCServiceDesk__Priority__c, BMCServiceDesk__RF_HasAttachments__c, BMCServiceDesk__Problem_Description__c, BMCServiceDesk__Problem_Resolution__c, BMCServiceDesk__Problem_Source__c, BMCServiceDesk__Problem_console_detail_link__c, BMCServiceDesk__ShowDueDateDialog__c, BMCServiceDesk__Staff_ID_Closed_By__c, BMCServiceDesk__State__c, BMCServiceDesk__Status__c, BMCServiceDesk__Task_Closed_Controller__c, BMCServiceDesk__UpdateCount__c, BMCServiceDesk__Urgency__c, BMCServiceDesk__Work_Around__c, BMCServiceDesk__Workaround_details__c, BMCServiceDesk__queueName__c, BMCServiceDesk__shortDescription__c, BMCServiceDesk__Number_of_linked_Changes__c, BMCServiceDesk__Number_of_linked_Incidents__c, BMCServiceDesk__Total_Duration__c, Additional_Email_id__c, Corrective_action__c, Expected_Demo_time__c, Ticket_Ranking__c, Expected_Permanent_Solution_Time__c, First_respone_time__c, Identification__c, Issue_escaped__c, KEDB_Updated__c, Preventive_action__c, PriorityName__c, Product__c, Reported_By__c, Resolution_Time__c, Root_Cause_analysis__c, Share_Outage_report_with_customer__c, Subject__c, Test_Successful__c, Workaround_provided__c, Workaround_time__c, test11__c, QA_status__c, Capability_Issue_Team__c, ERT_Type__c, Issue_Escaped_ENGG__c, Bug_ID__c, Target_Release_Date__c, Delivered_in_Release_Patch__c, ENGG_Comments__c, ERT__c, Team__c, BMCServiceDesk__Deep_View__c, Email_Listener__c, BMCServiceDesk__LockedRecordTimestamp__c, Account__c, Assigned_To__c, SF_NO__c, BMCServiceDesk__Queue__c, Actual_Release_Date__c, Alert_Type__c, App_support_Capability_Counter__c, AppSupport_Follow_Up__c, Appsupport_RCA__c, AppSupport_resolve_Date_Time__c, Appsupport_Status__c, AppSupportc_Start_Date_Time__c, AppSupport_Member__c, Awaiting_Update_RCA_on__c, Browser_Name_Version__c, Bugzilla_Rally_URL__c, Additional_Details__c, Problem_Type__c, Problem_Type_AS__c, Problem_Sub_Type_AS__c, Comments__c, Company_Name__c, Date_and_Time_when_issue_occurred__c, Did_you_clear_Browser_cache_and_Cookies__c, Dupl_Problem_ID__c, Duplicate_Ticket_URL__c, Exact_Steps__c, Feature_Request_Status__c, Issue_can_be_reproduced_at_Support_Login__c, Issue_Escaped_by__c, JIRA_Story__c, Major_functionality_is_impacted__c, PMG_Comments__c, PMG_priority__c, PMG_Status__c, Screenshot_attached_in_the_Ticket__c, Severity__c, Support_Team__c, Target_Release_Number__c, Ticket_Assigned_To_L2__c, User_Name__c, Original_Case_URL__c, Internal_ERT__c, Workaround_Available__c, Workaround__c, Esc_to_L3_on__c, AN__c, Escalated__c, Product1__c, ADay__c, AHour__c, ENGG_Analysis__c, Delivery_Priority__c, Approval__c, Module__c, Sprint_Cycle__c, Record_ID_18_Characters__c, Next_Update_Due__c, Intercept_Corrective_Action__c, Intercept_Preventive_Action__c, CAPA_Implementation__c, CAPA_Type__c, Next_Steps_Owner__c, Next_Steps__c, Target_Release_Train__c, Sub_Product__c, Delivery_Priority_DateTime__c, Revised_Release_Train__c, Planned_Release_Train__c, Assigned_to_Time_Capture__c, TeamT__c, Dev_Assigned__c, QC_Assigned__c, Dev_QC_Status__c, Planned_Development_Week__c, RCA_and_CAPA_Acceptance__c, BMCServiceDesk__RF_Attachments__c, SLA_status__c, ConnectionReceivedId, ConnectionSentId, Name, Id
                                         FROM BMCServiceDesk__Problem__c WHERE
                                         Id NOT IN (Select VLSF_LINK_BMC_Problem__c from Problem)
                                         order by CreatedDate DESC]);
             //  AND CALENDAR_YEAR(CreatedDate)=:year
    }
    
    public void execute(Database.BatchableContext BC, List<BMCServiceDesk__Problem__c> scope){
        
        Id recordId;
        System.debug('## Size ' + scope.size() + ' case records');
        List<ContentDocumentLink> newContentLink = new List<ContentDocumentLink>();
        List<Migration_Field_Mapping__mdt> fieldMapping = [SELECT MasterLabel, QualifiedApiName, Field_Mapping__c, Salesforce_Field__c, BMC_Field__c
                                                           FROM Migration_Field_Mapping__mdt
                                                           where MasterLabel like '% P' OR MasterLabel like '% ph'];
        List<Problem> newProblemList = new List<Problem>();
        Map<Id, Problem> problmeIdMap = new Map<Id, Problem>();
        Set<Id> problemIds = new Set<Id>();
        List<VLSF_Problem_Historical_Data__c> newProblemHistoryList = new List<VLSF_Problem_Historical_Data__c>();
        List<Schema.PicklistEntry> picklistValues = Schema.SObjectType.Problem.fields.getMap().get('VLSF_Assigned_To__c').getDescribe().getPicklistValues();
        System.debug('picklistValues:::' + picklistValues);
        Map<String, String> values = new Map<string, String>();
        For (Schema.PicklistEntry pick : picklistValues){
            
            values.put(pick.getLabel(), pick.getValue());
        }
        If (!scope.isEmpty()){
            for (BMCServiceDesk__Problem__c prob : scope){
                recordId = prob.Id;
                Problem newProblem = new Problem();
                for (Migration_Field_Mapping__mdt mapping : fieldMapping){
                    // Map Incident fields to Case fields based on custom metadata
                    if (prob.get(mapping.BMC_Field__c) != null && mapping.Field_Mapping__c == 'Problem'){
                    
                                            
                        if (mapping.Salesforce_Field__c == 'VLSF_Assigned_To__c'){
                            System.debug('prob Mapping VLSF_Assigned_To__c::' + prob.get(mapping.BMC_Field__c));
                            String fieldValue = String.valueOf(prob.get(mapping.BMC_Field__c)).trim();
                            newProblem.put(mapping.Salesforce_Field__c, fieldValue);
                        }
                        if(mapping.Salesforce_Field__c == 'Status' || mapping.BMC_Field__c == 'BMCServiceDesk__Status__c'){ 
                            String value = '';
                            String resolutionCode = '';
                            if( prob.get(mapping.BMC_Field__c) == 'Resolved' ||  prob.get(mapping.BMC_Field__c) == 'Resolved – Customer Confirmation Awaited' || prob.get(mapping.BMC_Field__c) == 'Customer Confirmation Awaited' ) {
                                value = 'Resolved';
                                resolutionCode = 'Customer Confirmation awaited';
                            } else if( prob.get(mapping.BMC_Field__c) == 'Closed Unresolved' || prob.get(mapping.BMC_Field__c) == 'Invalid' || prob.get(mapping.BMC_Field__c) == 'Awaiting Deployment') {
                                value = 'Closed';
                            } else if( prob.get(mapping.BMC_Field__c) == 'Resolved Duplicate'){
                                value = 'Resolved';
                                resolutionCode='Duplicate';
                            }  else if( prob.get(mapping.BMC_Field__c) == 'Invalid'){
                                value = 'Closed';
                                resolutionCode='Invalid';
                            } else if( prob.get(mapping.BMC_Field__c) == 'Under Monitoring' || prob.get(mapping.BMC_Field__c) == 'In Progress'){
                                value = 'Work In Progress';
                                resolutionCode='Work in Progress';
                            } else if( prob.get(mapping.BMC_Field__c) == 'RCA & Corrective-Action Provided'){
                                value = 'Resolved';
                                resolutionCode='RCA & Corrective-Action Provided';
                            } else if( prob.get(mapping.BMC_Field__c) == 'Resolved – Customer Confirmation'){
                                value = 'Resolved';
                                resolutionCode='Resolved';
                            }
                            if (value !=null) {
                                newProblem.put('Status', value);
                            }
                            if (resolutionCode !=null) {
                                newProblem.put('VLSF_Resolution_Code__c', resolutionCode);
                            }
                        }
                        else{
                           newProblem.put(mapping.Salesforce_Field__c, prob.get(mapping.BMC_Field__c)); 
                        }
                        
                        
                       
                    }
                  
                     if (newProblem.get('Subject') == null) {
                            // Put the Subject value in newProblem
                            newProblem.put('Subject', 'NA');
                        }
                                         if (newProblem.get('Status') == null) {
                            // Put the Subject value in newProblem
                            newProblem.put('Status', 'Opened');
                        }
                }
                VLSF_Problem_Historical_Data__c newProblemHis = new VLSF_Problem_Historical_Data__c();
                for (Migration_Field_Mapping__mdt mappings : fieldMapping){
                    // Map Incident fields to Case fields based on custom metadata
                    if (prob.get(mappings.BMC_Field__c) != null && mappings.Field_Mapping__c == 'ph'){                         
                        if (mappings.Salesforce_Field__c == 'VLSF_Link_BMC_Problem__c' && mappings.BMC_Field__c=='Id'){
                            newProblemHis.put(mappings.Salesforce_Field__c, prob.get(mappings.BMC_Field__c));
                        } else{
                            newProblemHis.put(mappings.Salesforce_Field__c, String.valueOf(prob.get(mappings.BMC_Field__c)));
                        }
                    }
                }
                // Insert the Case record
                newProblemList.add(newProblem);
                newProblemHistoryList.add(newProblemHis);
                problemIds.add(prob.Id);
                problmeIdMap.put(prob.Id, newProblem);
            }
        }
        
        if (!newProblemList.isEmpty()){
            //insert newCaseList;
            Database.SaveResult[] newProblemSave = Database.insert(newProblemList, false);
            List<String> allErrors = new List<String>();
            List<String> errorContexts = new List<String>();
            Integer errorCounter=0;
            String listOfErrorMessages = '';
            // Iterate through each returned result
            For(Database.SaveResult srList: newProblemSave){
                if (srList.isSuccess()){
              
                } 
                else{
                    for(Database.Error err : srList.getErrors()) {
                        errorContexts.add(err.getMessage());
                        errorCounter= errorCounter + 1;
                        listOfErrorMessages = 'recordId : '+recordId+': {"errorMesage" : '+err.getFields()+' : '+err.getMessage()+'"},';
                        
                    }
                    //System.debug('Case fields that affected this error: ' + srList.getErrors());
                    allErrors.add(listOfErrorMessages);
                }   
            }
            if (!allErrors.isEmpty()) {
                String stringValues = JSON.serializePretty(allErrors);
                String removeSlash = stringValues.replaceAll('\\\\', '').replaceAll('\\"', '"').replaceAll('\\{', '{').replaceAll('\\}', '}');
                VLSF_ExceptionLog.ErrorLogMigration( JSON.serialize(errorContexts),JSON.serialize(removeSlash),errorCounter);
            }
        }
        
        System.debug(newProblemHistoryList);
        if (!newProblemHistoryList.isEmpty()){
            //insert newCaseList;
            Database.SaveResult[] newProbHis = Database.insert(newProblemHistoryList, false);
            List<String> allErrors = new List<String>();
            List<String> errorContexts = new List<String>();
            Integer errorCounter=0;
            String listOfErrorMessages = '';
            // Iterate through each returned result
            For(Database.SaveResult srList: newProbHis){
                if (srList.isSuccess()){
                    // Operation was successful, so get the ID of the record that was processed
                  
                } 
                else{
                    for(Database.Error err : srList.getErrors()) {
                        errorContexts.add(err.getMessage());
                        errorCounter= errorCounter + 1;
                        listOfErrorMessages = 'recordId : '+recordId+': {"errorMesage" : '+err.getFields()+' : '+err.getMessage()+'"},';
                        
                    }
                    //System.debug('Case fields that affected this error: ' + srList.getErrors());
                    allErrors.add(listOfErrorMessages);
                }   
            }
            if (!allErrors.isEmpty()) {
                String stringValues = JSON.serializePretty(allErrors);
                String removeSlash = stringValues.replaceAll('\\\\', '').replaceAll('\\"', '"').replaceAll('\\{', '{').replaceAll('\\}', '}');
                VLSF_ExceptionLog.ErrorLogMigration( JSON.serialize(errorContexts),JSON.serialize(removeSlash),errorCounter);
            }
        }
        for (VLSF_Problem_Historical_Data__c hisData : newProblemHistoryList){
            hisData.VLSF_Link_Problem__c = problmeIdMap.get(hisData.VLSF_Link_BMC_Problem__c).Id;
        }
        Database.SaveResult[] newProbHis = Database.update(newProblemHistoryList, false);
         
    }
    
    public void finish(Database.BatchableContext BC){
        // No post-processing needed
    }
    
}