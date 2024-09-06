public class VLSF_MigrateAttachments implements Database.Batchable<sObject> {
    
    public Integer counterForErrorMessages=0;
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        Migration_Field_Mapping__mdt fieldMapping = [SELECT MasterLabel, QualifiedApiName, VLSF_Calender_Year__c
                                                     FROM Migration_Field_Mapping__mdt
                                                     WHERE MasterLabel LIKE '%CALENDAR_YEAR%' LIMIT 1];
        Integer year = Integer.valueOf(fieldMapping.VLSF_Calender_Year__c);
        return Database.getQueryLocator([SELECT Id, VLSF_Link_Incident__c, VLSF_Opened_Date__c 
                                         FROM Case 
                                         WHERE VLSF_Link_Incident__c != NULL AND 
                                               CALENDAR_YEAR(VLSF_Link_Incident__r.BMCServiceDesk__openDateTime__c) = :year 
                                         ORDER BY VLSF_Link_Incident__r.BMCServiceDesk__openDateTime__c DESC]);
    }
    
    public void execute(Database.BatchableContext BC, List<Case> scope){
        
        Map<Id, Case> caseIncidentMap = new Map<Id, Case>();
        Set<Id> setOfCaseIds = new Set<Id>();
        Set<Id> setOfincidentIds = new Set<Id>();
        
        for(Case ca : scope){
            caseIncidentMap.put(ca.VLSF_Link_Incident__c, ca);
            setOfCaseIds.add(ca.Id);
            setOfincidentIds.add(ca.VLSF_Link_Incident__c);
        }
        
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
        
        List<Attachment> attachments = [SELECT Id, Body, Name, ParentId
                                        FROM Attachment
                                        WHERE ParentId IN :caseIncidentMap.keySet()];
        Set<Id> attachmentIds = new Set<Id>();
        for (Attachment att : attachments) {
            attachmentIds.add(att.Id);
        }
        
        List<ContentVersion> existingContentVersions = [SELECT Id, VLSF_Attachment_Id__c 
                                                        FROM ContentVersion 
                                                        WHERE VLSF_Attachment_Id__c IN :attachmentIds];
        
        Set<Id> existingAttachmentIds = new Set<Id>();
        for (ContentVersion cv : existingContentVersions) {
            existingAttachmentIds.add(cv.VLSF_Attachment_Id__c);
        }
        
        List<ContentVersion> contentVersionsToInsert = new List<ContentVersion>();
        for (Attachment att : attachments) {
            if (!existingAttachmentIds.contains(att.Id)) {
                contentVersionsToInsert.add(new ContentVersion(
                    Title = att.Name,
                    PathOnClient = '/' + att.Name,
                    VLSF_Attachment_Id__c = att.Id,
                    VersionData = att.Body,
                    FirstPublishLocationId = att.ParentId,
                    IsMajorVersion = true
                ));
            }
        }
        
        if (!contentVersionsToInsert.isEmpty()) {
            insert contentVersionsToInsert;
            
            Map<Id, Id> contentVersionToDocumentMap = new Map<Id, Id>();
            List<ContentVersion> insertedContentVersions = [SELECT Id, ContentDocumentId, FirstPublishLocationId 
                                                            FROM ContentVersion 
                                                            WHERE Id IN :contentVersionsToInsert];
            for (ContentVersion cv : insertedContentVersions) {
                contentVersionToDocumentMap.put(cv.Id, cv.ContentDocumentId);
            }
            
            List<ContentDocumentLink> contentDocumentLinksToInsert = new List<ContentDocumentLink>();
            for (ContentVersion cv : insertedContentVersions) {
                Case relatedCase = caseIncidentMap.get(cv.FirstPublishLocationId);
                if (relatedCase != null) {
                    contentDocumentLinksToInsert.add(new ContentDocumentLink(
                        LinkedEntityId = relatedCase.Id, 
                        ContentDocumentId = contentVersionToDocumentMap.get(cv.Id),
                        ShareType = 'V', 
                        Visibility = 'AllUsers'
                    ));
                }
            }
            insert contentDocumentLinksToInsert;
        }
        
        if (!newContentLink.isEmpty()) {
            insert newContentLink;
        }
    }
    
    public void finish(Database.BatchableContext BC){
        // No post-processing needed
    }
}