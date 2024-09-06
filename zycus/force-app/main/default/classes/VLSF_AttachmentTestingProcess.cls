public class VLSF_AttachmentTestingProcess implements Database.Batchable<sObject> {
    
    public Integer counterForErrorMessages = 0;
    public Map<Id, Set<String>> caseContentNamesMap = new Map<Id, Set<String>>();
    public Map<String, Id> globalContentTitleToDocumentIdMap = new Map<String, Id>();
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Migration_Field_Mapping__mdt year = Migration_Field_Mapping__mdt.getInstance('CALENDAR_YEAR');
        
        Integer yearNum = Integer.valueOf(year.VLSF_Calender_Year__c);
        Integer monthNum = Integer.valueOf(year.LAST_N_Days__c);
        
        return Database.getQueryLocator([
            SELECT Id, Body, Name, ParentId, OwnerId
            FROM Attachment
            WHERE ParentId IN (
                SELECT Id FROM BMCServiceDesk__Incident__c 
                WHERE CALENDAR_YEAR(BMCServiceDesk__openDateTime__c) = :yearNum
                AND CALENDAR_MONTH(BMCServiceDesk__openDateTime__c) = :monthNum
                
            )
        ]);
    }
    
    public void execute(Database.BatchableContext BC, List<Attachment> scope) {
        try {
            Set<Id> incidentIds = new Set<Id>();
            for (Attachment att : scope) {
                incidentIds.add(att.ParentId);
            }
            //System.debug('incidentIds: ' + incidentIds);
            
            Map<Id, Case> incidentToCaseMap = new Map<Id, Case>();
            List<Case> relatedCases = [
                SELECT Id, VLSF_Link_Incident__c 
                FROM Case 
                WHERE VLSF_Link_Incident__c IN :incidentIds
            ];
            for (Case ca : relatedCases) {
                incidentToCaseMap.put(ca.VLSF_Link_Incident__c, ca);
            }
            //System.debug('incidentToCaseMap: ' + incidentToCaseMap);
            
            Set<Id> caseIds = new Set<Id>();
            for (Case ca : relatedCases) {
                caseIds.add(ca.Id);
            }
            //System.debug('caseIds: ' + caseIds);
            
            List<ContentDocumentLink> caseContentLinks = [
                SELECT ContentDocumentId, LinkedEntityId
                FROM ContentDocumentLink
                WHERE LinkedEntityId IN :caseIds
            ];
            //System.debug('caseContentLinks: ' + caseContentLinks);
            
            Set<Id> contentDocumentIds = new Set<Id>();
            for (ContentDocumentLink cdl : caseContentLinks) {
                contentDocumentIds.add(cdl.ContentDocumentId);
            }
            //System.debug('contentDocumentIds: ' + contentDocumentIds);
            
            List<ContentVersion> contentVersions = [
                SELECT Id, Title, PathOnClient, FileType, ContentDocumentId,VLSF_Attachment_ID_Unique__c
                FROM ContentVersion
                WHERE ContentDocumentId IN :contentDocumentIds AND FileType != 'SNOTE'
            ];
            //System.debug('contentVersions: ' + contentVersions);
            
            Map<Id, String> contentDocumentIdToTitleMap = new Map<Id, String>();
            for (ContentVersion cv : contentVersions) {
                String AttachId = cv.VLSF_Attachment_ID_Unique__c;
                contentDocumentIdToTitleMap.put(cv.ContentDocumentId, AttachId);
                globalContentTitleToDocumentIdMap.put(AttachId, cv.ContentDocumentId);
            }
            //System.debug('contentDocumentIdToTitleMap: ' + contentDocumentIdToTitleMap);
            
            for (ContentDocumentLink cdl : caseContentLinks) {
                String title = contentDocumentIdToTitleMap.get(cdl.ContentDocumentId);
                if (title != null) {
                    if (!caseContentNamesMap.containsKey(cdl.LinkedEntityId)) {
                        caseContentNamesMap.put(cdl.LinkedEntityId, new Set<String>());
                    }
                    caseContentNamesMap.get(cdl.LinkedEntityId).add(title);
                }
            }
            //System.debug('caseContentNamesMap: ' + caseContentNamesMap);
            
            List<ContentVersion> contentVersionsToInsert = new List<ContentVersion>();
            List<ContentDocumentLink> contentDocumentLinksToInsert = new List<ContentDocumentLink>();
            Id recordId;
            for (Attachment incidentAtt : scope) {
                Case relatedCase = incidentToCaseMap.get(incidentAtt.ParentId);
                if (relatedCase != null) {
                    Set<String> existingNames = caseContentNamesMap.get(relatedCase.Id);
                    String AttachId = incidentAtt.Id;
                    recordId=incidentAtt.Id;
                    if (existingNames == null || !existingNames.contains(AttachId)) {
                        
                        // New content version
                        ContentVersion cVersion = new ContentVersion();
                        cVersion.ContentLocation = 'S';
                        cVersion.PathOnClient = incidentAtt.Name;
                        cVersion.Origin = 'H';
                       // cVersion.OwnerId = incidentAtt.OwnerId;
                        cVersion.Title = incidentAtt.Name;
                        cVersion.VersionData = incidentAtt.Body;
                        cVersion.VLSF_Attachment_ID_Unique__c=incidentAtt.Id;
                        cVersion.VLSF_Incident_ID__c=incidentAtt.ParentId;
                        contentVersionsToInsert.add(cVersion);
                        
                    }
                }
            }
            //System.debug('contentVersionsToInsert: ' + contentVersionsToInsert.size());
            
            if (!contentVersionsToInsert.isEmpty()) {
                Database.SaveResult[] insertResults = Database.insert(contentVersionsToInsert, false);
                //System.debug('insertResults: ' + insertResults);
                List<String> allErrors = new List<String>();
                List<String> errorContexts = new List<String>();
                Integer errorCounter=0;
                String listOfErrorMessages = '';
                Map<Id, Id> contentVersionToDocumentMap = new Map<Id, Id>();
                List<Id> successfulContentVersionIds = new List<Id>();
                
                for (Integer i = 0; i < insertResults.size(); i++) {
                    if (insertResults[i].isSuccess()) {
                        successfulContentVersionIds.add(contentVersionsToInsert[i].Id);
                    }
                    else{
                        for(Database.Error err : insertResults[i].getErrors()) {
                            errorContexts.add(err.getMessage());
                            errorCounter= errorCounter + 1;
                            listOfErrorMessages = 'recordId : '+recordId+': {"errorMesage from VLSF_MigrateCases" : '+err.getFields()+' : '+err.getMessage()+'"},';
                        }
                        //System.debug('Case fields that affected this error: ' + srListHis.getErrors());
                        allErrors.add(listOfErrorMessages);
                        //errorContexts.add(JSON.serialize(srListHis.getErrorMessage()));
                    }   
                }
                //System.debug('successfulContentVersionIds: ' + successfulContentVersionIds);
                
                if (!successfulContentVersionIds.isEmpty()) {
                    List<ContentVersion> successfulContentVersions = [
                        SELECT Id, ContentDocumentId
                        FROM ContentVersion
                        WHERE Id IN :successfulContentVersionIds
                    ];
                    
                    for (ContentVersion cVersion : successfulContentVersions) {
                        contentVersionToDocumentMap.put(cVersion.Id, cVersion.ContentDocumentId);
                    }
                    //System.debug('contentVersionToDocumentMap: ' + contentVersionToDocumentMap);
                    
                    for (Integer i = 0; i < insertResults.size(); i++) {
                        if (insertResults[i].isSuccess()) {
                            Id contentVersionId = contentVersionsToInsert[i].Id;
                            Id contentDocumentId = contentVersionToDocumentMap.get(contentVersionId);
                            
                            Attachment incidentAtt = scope[i];
                            Case relatedCase = incidentToCaseMap.get(incidentAtt.ParentId);
                            if (relatedCase != null) {
                                ContentDocumentLink cDocLink = new ContentDocumentLink();
                                cDocLink.ContentDocumentId = contentDocumentId;
                                cDocLink.LinkedEntityId = relatedCase.Id;
                                cDocLink.ShareType = 'I';
                                cDocLink.Visibility = 'AllUsers';
                                contentDocumentLinksToInsert.add(cDocLink);
                                
                                // Add the new content version to the global map
                                globalContentTitleToDocumentIdMap.put(incidentAtt.Name, contentDocumentId);
                            }
                        }
                    }
                    //  System.debug('contentDocumentLinksToInsert: ' + contentDocumentLinksToInsert.size());
                    
                    if (!contentDocumentLinksToInsert.isEmpty()) {
                        Database.insert(contentDocumentLinksToInsert, false);
                    }
                    if (!allErrors.isEmpty()) {
                        String stringValues = JSON.serializePretty(allErrors);
                        String removeSlash = stringValues.replaceAll('\\\\', '').replaceAll('\\"', '"').replaceAll('\\{', '{').replaceAll('\\}', '}');
                        VLSF_ExceptionLog.ErrorLogMigration( JSON.serialize(errorContexts),JSON.serialize(allErrors),errorCounter, 'Migration');
                    }
                    
                }
            }
        } catch (Exception e) {
            System.debug('Error in execute method: ' + e.getMessage());
            counterForErrorMessages++;
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
}