public class VLSF_MigrateNotes implements Database.Batchable<sObject> {
    public Integer counterForErrorMessages = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Migration_Field_Mapping__mdt fieldMapping = [
            SELECT MasterLabel, QualifiedApiName, VLSF_Calender_Year__c
            FROM Migration_Field_Mapping__mdt 
            WHERE MasterLabel like '%CALENDAR_YEAR%' 
            LIMIT 1
        ];
        Integer year = Integer.valueOf(fieldMapping.VLSF_Calender_Year__c);
        return Database.getQueryLocator([
            SELECT Body, CreatedById, CreatedDate, Id, IsDeleted, IsPrivate, LastModifiedById, LastModifiedDate, OwnerId, ParentId, SystemModstamp, Title
            FROM Note 
             WHERE CALENDAR_YEAR(CreatedDate) = :year 
            AND ParentId IN (SELECT Id FROM BMCServiceDesk__Incident__c)
            AND ParentId NOT IN (SELECT VLSF_Linked_Incident__c FROM VLSF_Custom_Note__c)
            ORDER BY CreatedDate DESC
        ]);
    }
    
    public void execute(Database.BatchableContext BC, List<Note> scope) {
        Set<Id> incidentId = new Set<Id>();
          Set<Id> ownerIds = new Set<Id>();
        Map<Id, Id> IncidentCaseIds = new Map<Id, Id>();
        Id recordId;
        
        for (Note data : scope) {
            incidentId.add(data.ParentId);
        }
        
        List<Case> CaseData = [SELECT Id, VLSF_Link_Incident__c FROM Case WHERE VLSF_Link_Incident__c IN :incidentId];
         Map<Id, User> userMap = new Map<Id, User>([SELECT Id, IsActive FROM User WHERE Id IN :ownerIds]);

        
        for (Case cs : CaseData) {
            IncidentCaseIds.put(cs.VLSF_Link_Incident__c, cs.Id);
        }
        
        List<VLSF_Custom_Note__c > notesFoInsert=new List<VLSF_Custom_Note__c >();
        
        for(Note note:scope){
            recordId=note.Id;
            VLSF_Custom_Note__c customNote=new VLSF_Custom_Note__c();
            customNote.VLSF_Title__c=String.valueOf(note.Title);
            customNote.VLSF_Description__c=String.valueOf(note.Body);
            customNote.VLSF_Created_Date__c=Date.valueOf(note.CreatedDate);
            customNote.VLSF_IsDeleted__c=Boolean.ValueOf(note.IsDeleted);
            customNote.VLSF_IsPrivate__c=Boolean.valueOf(note.IsPrivate);
            customNote.VLSF_Case__c=IncidentCaseIds.get(note.ParentId);
            customNote.VLSF_Linked_Incident__c=note.ParentId;
            customNote.VLSF_Linked_Note_Id__c=String.valueOf(note.Id);
             customNote.OwnerId = note.OwnerId;
       

            notesFoInsert.add(customNote);
        }
        
        if (!notesFoInsert.isEmpty()){
            //insert newCaseHistoryList;
            Database.SaveResult[] newNoteHisSave = Database.insert(notesFoInsert, false);
            List<String> allErrors = new List<String>();
            List<String> errorContexts = new List<String>();
            Integer errorCounter=0;
            String listOfErrorMessagesHis = '';
            // Iterate through each returned result
            For(Database.SaveResult srList: newNoteHisSave){
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
                        listOfErrorMessagesHis = 'recordId : '+recordId+': {"errorMesage" : '+err.getFields()+' : '+err.getMessage()+'"},';
                    }
                    //System.debug('Case fields that affected this error: ' + srList.getErrors());
                    allErrors.add(listOfErrorMessagesHis);
                    //errorContexts.add(JSON.serialize(srList.getErrorMessage()));
                }   
            }
            if (!allErrors.isEmpty()) {
                String stringValues = JSON.serializePretty(allErrors);
                String removeSlash = stringValues.replaceAll('\\\\', '').replaceAll('\\"', '"').replaceAll('\\{', '{').replaceAll('\\}', '}');
                VLSF_ExceptionLog.ErrorLogMigration( JSON.serialize(errorContexts),JSON.serialize(allErrors),errorCounter,'Notes');
            }
            // Add any further processing logic here if needed
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        // No post-processing needed
    }
}