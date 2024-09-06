public class VLSF_AttachmentProcess implements Database.Batchable<sObject> {
    
    public Integer counterForErrorMessages=0;
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        try{
            Migration_Field_Mapping__mdt year = Migration_Field_Mapping__mdt.getInstance('CALENDAR_YEAR');
            
            Integer yearNum = Integer.valueOf(year.VLSF_Calender_Year__c);
            Integer monthNum = Integer.valueOf(year.LAST_N_Days__c);
            // First, get the IDs of cases that have attachments
            Set<Id> caseIdsWithAttachments = new Set<Id>();
            
            for (ContentDocumentLink link : [SELECT LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN 
                                             (SELECT Id FROM Case WHERE VLSF_Link_Incident__c != NULL 
                                              AND CALENDAR_YEAR(VLSF_Link_Incident__r.BMCServiceDesk__openDateTime__c) = :yearNum 
                                              AND CALENDAR_MONTH(VLSF_Link_Incident__r.BMCServiceDesk__openDateTime__c) = :monthNum )]) 
            {
                caseIdsWithAttachments.add(link.LinkedEntityId);
            }
            
            for (ContentVersion version : [SELECT FirstPublishLocationId FROM ContentVersion WHERE FirstPublishLocationId IN 
                                           (SELECT Id FROM Case WHERE VLSF_Link_Incident__c != NULL 
                                            AND CALENDAR_YEAR(VLSF_Link_Incident__r.BMCServiceDesk__openDateTime__c) = :yearNum 
                                            AND CALENDAR_MONTH(VLSF_Link_Incident__r.BMCServiceDesk__openDateTime__c) = :monthNum )])
            {
                caseIdsWithAttachments.add(version.FirstPublishLocationId);
            }
            
            // Main query to get cases without attachments
            return Database.getQueryLocator([
                SELECT Id, VLSF_Link_Incident__c, VLSF_Opened_Date__c 
                FROM Case 
                WHERE VLSF_Link_Incident__c != NULL 
                AND CALENDAR_YEAR(VLSF_Link_Incident__r.BMCServiceDesk__openDateTime__c) = :yearNum
                AND CALENDAR_MONTH(VLSF_Link_Incident__r.BMCServiceDesk__openDateTime__c) = :monthNum
                AND Id NOT IN :caseIdsWithAttachments
                ORDER BY VLSF_Link_Incident__r.BMCServiceDesk__openDateTime__c DESC
            ]);
        } catch (Exception e) {
            System.debug('Error in start method: ' + e.getMessage());
            throw e;
        }
    }
    
    public void execute(Database.BatchableContext BC, List<Case> scope){
        Map<Id, Case> caseIncidentMap = new Map<Id, Case>();
        Set<Id> setOfCaseIds = new Set<Id>();
        Set<Id> setOfincidentIds = new Set<Id>();
        Id recordId;
        for(Case ca : scope){
            caseIncidentMap.put(ca.VLSF_Link_Incident__c, ca);
            setOfCaseIds.add(ca.Id);
            setOfincidentIds.add(ca.VLSF_Link_Incident__c);
        }
        System.debug('setOfCaseIds'+setOfCaseIds);
        System.debug('setOfincidentIds'+setOfincidentIds);
        List<ContentDocumentLink> contentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId 
                                                          FROM ContentDocumentLink 
                                                          WHERE LinkedEntityId IN :setOfCaseIds OR LinkedEntityId IN :setOfincidentIds];
        
        Set<Id> existingContentDocumentIdForCases = new Set<Id>();
        List<ContentDocumentLink> newContentLink = new List<ContentDocumentLink>();
        
        for(ContentDocumentLink cdl : contentDocumentLinks){
            if(setOfCaseIds.contains(cdl.LinkedEntityId)){
                existingContentDocumentIdForCases.add(cdl.ContentDocumentId);
            } else if(setOfincidentIds.contains(cdl.LinkedEntityId) && !existingContentDocumentIdForCases.contains(cdl.ContentDocumentId)){
                newContentLink.add(new ContentDocumentLink(
                    LinkedEntityId = caseIncidentMap.get(cdl.LinkedEntityId).Id,
                    ContentDocumentId = cdl.ContentDocumentId,
                    ShareType = 'V',
                    Visibility = 'AllUsers'
                ));
            }
        }
        
        List<Attachment> attachments = [SELECT Id, Body, Name, ParentId, OwnerId 
                                        FROM Attachment
                                        WHERE ParentId IN :caseIncidentMap.keySet()];
        Set<Id> attachmentIds = new Set<Id>();
        for (Attachment att : attachments) {
            attachmentIds.add(att.Id);
        }
        
        List<ContentVersion> existingContentVersions = [SELECT Id, VLSF_Attachment_Id__c 
                                                        FROM ContentVersion 
                                                        WHERE VLSF_Attachment_Id__c IN :attachmentIds AND FirstPublishLocationId != null];
        
        System.debug('existingContentVersions'+existingContentVersions);
        
        Set<Id> existingAttachmentIds = new Set<Id>();
        for (ContentVersion cv : existingContentVersions) {
            existingAttachmentIds.add(cv.VLSF_Attachment_Id__c);
        }
        
        List<ContentVersion> contentVersionsToInsert = new List<ContentVersion>();
        for (Attachment att : attachments) {
            recordId = att.ParentId;
            if (!existingAttachmentIds.contains(att.Id)) {
                contentVersionsToInsert.add(new ContentVersion(
                    Title = att.Name,
                    PathOnClient = '/' + att.Name,
                    VLSF_Attachment_Id__c = att.Id,
                    VersionData = att.Body,
                    FirstPublishLocationId = att.ParentId,
                    OwnerId = att.OwnerId,
                    IsMajorVersion = true
                ));
            }
        }
        
        if (!contentVersionsToInsert.isEmpty()){
            //insert newCaseHistoryList;
            Database.SaveResult[] newCaseHisSave = Database.insert(contentVersionsToInsert, false);
            List<String> allErrors = new List<String>();
            List<String> errorContexts = new List<String>();
            Integer errorCounter=0;
            String listOfErrorMessagesHis = '';
            // Iterate through each returned result
            For(Database.SaveResult srList: newCaseHisSave){
                counterForErrorMessages = counterForErrorMessages + 1;
                if (srList.isSuccess()){
                } else{
                    for(Database.Error err : srList.getErrors()) {
                        System.debug('err 152:::'+err);
                        System.debug('err 152:::'+err.getFields());
                        errorContexts.add(err.getMessage());
                        errorCounter= errorCounter + 1;
                        listOfErrorMessagesHis = 'recordId : '+recordId+': {"errorMesage from VLSF_AttachmentProcess" : '+err.getFields()+' : '+err.getMessage()+'"},';
                    }
                    //System.debug('Case fields that affected this error: ' + srList.getErrors());
                    allErrors.add(listOfErrorMessagesHis);
                    //errorContexts.add(JSON.serialize(srList.getErrorMessage()));
                }   
            }
            if (!allErrors.isEmpty()) {
                String stringValues = JSON.serializePretty(allErrors);
                String removeSlash = stringValues.replaceAll('\\\\', '').replaceAll('\\"', '"').replaceAll('\\{', '{').replaceAll('\\}', '}');
                VLSF_ExceptionLog.ErrorLogMigration( JSON.serialize(errorContexts),JSON.serialize(allErrors),errorCounter);
            }
        }
        
        if (!newContentLink.isEmpty()){
            //insert newContentLink;
            Database.SaveResult[] newCaseHisSave = Database.insert(newContentLink, false);
            List<String> allErrors = new List<String>();
            List<String> errorContexts = new List<String>();
            Integer errorCounter=0;
            String listOfErrorMessagesHis = '';
            // Iterate through each returned result
            For(Database.SaveResult srList: newCaseHisSave){
                counterForErrorMessages = counterForErrorMessages + 1;
                if (srList.isSuccess()){
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully updated case. Case ID: ' + srList);
                } else{
                    for(Database.Error err : srList.getErrors()) {
                        System.debug('err 152:::'+err);
                        System.debug('err 152:::'+err.getFields());
                        errorContexts.add(err.getMessage());
                        errorCounter= errorCounter + 1;
                        listOfErrorMessagesHis = 'recordId : '+recordId+': {"errorMesage from VLSF_AttachmentProcess" : '+err.getFields()+' : '+err.getMessage()+'"},';
                    }
                    //System.debug('Case fields that affected this error: ' + srList.getErrors());
                    allErrors.add(listOfErrorMessagesHis);
                    //errorContexts.add(JSON.serialize(srList.getErrorMessage()));
                }   
            }
            if (!allErrors.isEmpty()) {
                String stringValues = JSON.serializePretty(allErrors);
                String removeSlash = stringValues.replaceAll('\\\\', '').replaceAll('\\"', '"').replaceAll('\\{', '{').replaceAll('\\}', '}');
                VLSF_ExceptionLog.ErrorLogMigration( JSON.serialize(errorContexts),JSON.serialize(allErrors),errorCounter);
            }
        }
    }
    
    public void finish(Database.BatchableContext BC){
        // No post-processing needed
    }
}