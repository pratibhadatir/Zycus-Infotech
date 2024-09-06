public class VLSF_MigrationTask_2 implements Database.Batchable<sObject> {
    public Integer counterForErrorMessages=0;
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        Migration_Field_Mapping__mdt fieldMapping = [SELECT MasterLabel, QualifiedApiName, VLSF_Calender_Year__c
                                                     FROM Migration_Field_Mapping__mdt
                                                     Where MasterLabel like '%CALENDAR_YEAR%' LIMIT 1];
        Integer year = Integer.valueOf(fieldMapping.VLSF_Calender_Year__c);
        return Database.getQueryLocator([Select Id, VLSF_Link_Incident__c from Case Where
                                         CALENDAR_YEAR(VLSF_Link_Incident__r.BMCServiceDesk__openDateTime__c)=:year AND VLSF_Link_Incident__c!=null
                                         Order by VLSF_Link_Incident__r.BMCServiceDesk__openDateTime__c DESC 
                                        ]);
    }
    
    public void execute(Database.BatchableContext BC, List<Case> scope){

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
                                                                        Where BMCServiceDesk__FKIncident__c = :caseIncidentMap.keySet() And Id Not In (SELECT VLSF_Incident_History__c From EmailMessage)];
              Id recordId;
            for (BMCServiceDesk__IncidentHistory__c history : IncidentHistory){
                
                if (history.BMCServiceDesk__FKAction__r.Name.equalsIgnoreCase('Email Received') || history.BMCServiceDesk__FKAction__r.Name.equalsIgnoreCase('Email Sent')){
                    // Create EmailMessage for email actions
                    recordId =history.Id;
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
                } 
                
            }
        if(!emailsToInsert.isEmpty()){
            Database.SaveResult[] newCaseHisSave = Database.insert(emailsToInsert, false);
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
                VLSF_ExceptionLog.ErrorLogMigration( JSON.serialize(errorContexts),JSON.serialize(allErrors),errorCounter, 'Migration');
            }
        }
    }
    
    public void finish(Database.BatchableContext BC){
        // No post-processing needed
    }
}