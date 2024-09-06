public class VLSF_MigrateKnowledgeArticles implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        Migration_Field_Mapping__mdt fieldMapping = [SELECT MasterLabel, QualifiedApiName, VLSF_Calender_Year__c
                                                     FROM Migration_Field_Mapping__mdt 
                                                     Where MasterLabel like '%CALENDAR_YEAR%' LIMIT 1];
        Integer year = Integer.valueOf(fieldMapping.VLSF_Calender_Year__c);
        
        return Database.getQueryLocator([SELECT Id, BMCServiceDesk__Answer__c,OwnerId, BMCServiceDesk__Article_Number__c, BMCServiceDesk__Article_Type__c, BMCServiceDesk__Category__c, BMCServiceDesk__Checked_out__c, BMCServiceDesk__Closed_Date__c, BMCServiceDesk__CreateChangeRequest__c, BMCServiceDesk__Error_description__c, BMCServiceDesk__FKCategory__c, BMCServiceDesk__KA_Account_Links__c, BMCServiceDesk__Keywords__c, BMCServiceDesk__Original_Knowledge_Article__c, BMCServiceDesk__Problem__c, BMCServiceDesk__PublishedDate__c, BMCServiceDesk__Question__c, BMCServiceDesk__Relevance__c, BMCServiceDesk__Review_Date__c, BMCServiceDesk__Root_Cause__c, BMCServiceDesk__Solution__c, BMCServiceDesk__Status__c, BMCServiceDesk__Title__c, BMCServiceDesk__Used_by_Staff__c, BMCServiceDesk__View_Count__c, BMCServiceDesk__Visible_in_Self_Service__c, BMCServiceDesk__Workaround__c, BMCServiceDesk__Used_Count__c, BMCServiceDesk__Used_by_Staff_Members_Count__c, BMCServiceDesk__Used_in_Change__c, BMCServiceDesk__Used_in_Problem__c, flag_approved__c, Product__c, BMCServiceDesk__VideoHeight__c, BMCServiceDesk__VideoURL__c, BMCServiceDesk__VideoWidth__c, Issue_Symptom__c, Steps_for_Resolution__c, Additional_Information__c, Approval__c, Valid_for__c, Comment_if_Rejected__c, Name
                                         FROM BMCServiceDesk__KM_KnowledgeArticle__c
                                         Where Id NOT In (Select VLSF_Link_Knowledge_Article__c from Knowledge__kav) 
                                         //AND CALENDAR_YEAR(CreatedDate)=:year 
                                         Order by CreatedDate DESC
                                        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<BMCServiceDesk__KM_KnowledgeArticle__c> scope) {
        Id  recordId;
        List<ContentDocumentLink> newContentLink = new List<ContentDocumentLink>();
        List<Migration_Field_Mapping__mdt> fieldMapping = [SELECT MasterLabel, QualifiedApiName, Field_Mapping__c, Salesforce_Field__c, BMC_Field__c
                                                           FROM Migration_Field_Mapping__mdt
                                                           where MasterLabel like '% K' OR MasterLabel like '% kh'];
        List<Knowledge__kav> newKnowledgeList = new List<Knowledge__kav>();
        Map<Id, Knowledge__kav> knowledgeIdMap = new Map<Id, Knowledge__kav>();
        Map<String, String> picklistValues = new Map<String, String>();
        Set<Id> knowledgeIds = new Set<Id>();
        List<Knowledge_Historical_Data__c> newKnowledgeHistoryList = new List<Knowledge_Historical_Data__c>();
        
        If (!scope.isEmpty()){
            for (BMCServiceDesk__KM_KnowledgeArticle__c know : scope){
                recordId = know.Id;
                Knowledge__kav newKnowledge = new Knowledge__kav();
                String fieldValue = '';
                for (Migration_Field_Mapping__mdt mapping : fieldMapping){
                    if (know.get(mapping.BMC_Field__c) != null && mapping.Field_Mapping__c == 'Knowledge'){
                        
                        newKnowledge.put(mapping.Salesforce_Field__c, know.get(mapping.BMC_Field__c));
                        if (mapping.BMC_Field__c == 'BMCServiceDesk__Title__c'){
                            fieldValue = String.valueOf(know.get(mapping.BMC_Field__c)).replaceAll(',', '-').toLowerCase().replaceAll(' ', '-');
                            fieldValue = fieldValue.replaceAll('[^\\p{L}\\p{Nd}-]', '-'); 
                            fieldValue = fieldValue.replaceAll('^-+', '').replaceAll('-+$', ''); 
                        }
                        if (mapping.Salesforce_Field__c == 'VLSF_Category__c'){
                            String fieldVal = String.valueOf(know.get(mapping.BMC_Field__c)).trim();
                            newKnowledge.put(mapping.Salesforce_Field__c, fieldVal);
                        }
                        
                    }
                }
                newKnowledge.UrlName = fieldValue+'-'+know.Name;
                
                Knowledge_Historical_Data__c newKnowledgeHis = new Knowledge_Historical_Data__c();
                for (Migration_Field_Mapping__mdt mappings : fieldMapping){
                    // Map Incident fields to Case fields based on custom metadata
                    if (know.get(mappings.BMC_Field__c) != null && mappings.Field_Mapping__c == 'kh'){
                        newKnowledgeHis.put(mappings.Salesforce_Field__c, String.valueOf(know.get(mappings.BMC_Field__c)));
                    }
                }
                newKnowledgeList.add(newKnowledge);
                newKnowledgeHistoryList.add(newKnowledgeHis);
                
                knowledgeIds.add(know.Id);
                knowledgeIdMap.put(know.Id, newKnowledge);
            }
        }
        if (!newKnowledgeList.isEmpty()){
            Database.SaveResult[] newKnowledSave = Database.insert(newKnowledgeList, false);
            List<String> allErrors = new List<String>();
            List<String> errorContexts = new List<String>();
            Integer errorCounter=0;
            String listOfErrorMessages = '';
            // Iterate through each returned result
            For(Database.SaveResult srList: newKnowledSave){
                if (srList.isSuccess()){
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully updated case. Case ID: ' + srList);
                } else{
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
        if (!newKnowledgeHistoryList.isEmpty()){
            Database.SaveResult[] newKnowledSave = Database.insert(newKnowledgeHistoryList, false);
            List<String> allErrors = new List<String>();
            List<String> errorContexts = new List<String>();
            Integer errorCounter=0;
            String listOfErrorMessages = '';
            // Iterate through each returned result
            For(Database.SaveResult srList: newKnowledSave){
                if (srList.isSuccess()){
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully updated case. Case ID: ' + srList);
                } else{
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
        
        for (Knowledge_Historical_Data__c hisData : newKnowledgeHistoryList){
            hisData.VLSF_Knowledge__c = knowledgeIdMap.get(hisData.VLSF_Link_Knowledge_Article__c).Id;
        }
        if (!newKnowledgeHistoryList.isEmpty()){
            update newKnowledgeHistoryList;
        }
        
    }
    public void finish(Database.BatchableContext bc) {
        // Perform any post-processing tasks if needed
    }
}