public class VLSF_RestrictEmailToCaseBatch implements Database.Batchable<SObject> {
    public Integer counterForErrorMessages=0;
    
    public Database.QueryLocator start(Database.BatchableContext bc) 
    {
        return Database.getQueryLocator([select Id, CaseNumber, Subject, Origin, SuppliedEmail, CreatedDate, Status, Description
                                         from Case where Subject LIKE '%(Ref:IN:%' AND (Subject LIKE 'RE:%' OR Subject LIKE 'AW:%') 
                                         AND 
                                         (VLSF_Opened_Date__c  = THIS_MONTH OR VLSF_Opened_Date__c  = LAST_MONTH ) 
                                         order by createdDate DESC
                                        ]);
    }
    public void execute(Database.BatchableContext bc, List<Case> scope) {
        Id recordId;
        List<String> incNames=new List<String>();
        List<EmailMessage> createEmailFromCase = New List<EmailMessage>();
        List<Case> caselistToDelete = new List<Case>();
        for(Case caseRecord: scope)
        {
            if(caseRecord.Subject!=null && caseRecord.Subject.toLowerCase().contains('(ref:in:'))
            {
                String sub=caseRecord.Subject.toLowerCase();
                Pattern regex = Pattern.compile('\\(ref:in:(\\d+)\\)');
                Matcher matcher = regex.matcher(sub);
                
                String incNumber;
                Map<Id, List<EmailMessage>> caseToEmail = new Map<Id, List<EmailMessage>>();
                if (matcher.find()) 
                {
                    // Extract the number found and store in a string
                    incNumber= matcher.group(1);
                    
                    incNames.add(incNumber);
                } 
                
            }
        } 
        
        Map<String, Id> casetoIncidentId = new Map<String, Id>();
        Map<String, Id> casenumberTocaseId = new Map<String, Id>();
        Map<Id, Case> caseMap = new Map<Id, Case>();
        
        List<Case> cases=[select Id, Subject, SuppliedEmail, Description, VLSF_Link_Incident__c, VLSF_Link_Incident__r.Name from Case where VLSF_Link_Incident__r.Name IN:incNames];
        
        List<Case> casesData=[select  Id,CaseNumber, Subject, SuppliedEmail, Description, VLSF_Link_Incident__c, VLSF_Link_Incident__r.Name from Case where CaseNumber IN:incNames];
        
        For(Case caseRec:cases){
            casetoIncidentId.put(caseRec.VLSF_Link_Incident__r.Name, caseRec.Id);
        }
        
        
        For(Case caseRec:casesData){
            casenumberTocaseId.put(caseRec.CaseNumber, caseRec.Id);
        }
        
        for (Case caseRecord : scope) {
            String sub = caseRecord.Subject.toLowerCase();
            Pattern regex = Pattern.compile('\\(ref:in:(\\d+)\\)');
            Matcher matcher = regex.matcher(sub);
            
            if (matcher.find()) {
                String incNumber = matcher.group(1);
                Id parentId = casetoIncidentId.get(incNumber);
                if (parentId == null) {
                    parentId = casenumberTocaseId.get(incNumber);
                }
                if (parentId != null) {
                    recordId = caseRecord.Id;
                    caseMap.put(recordId, caseRecord);
                    
                    EmailMessage email = new EmailMessage();
                    email.ParentId = parentId;
                    email.Subject = caseRecord.Subject;
                    email.TextBody = caseRecord.Description;
                    email.FromName = caseRecord.SuppliedEmail;
                    email.MessageDate = caseRecord.CreatedDate;
                    email.Incoming = true;
                    createEmailFromCase.add(email);
                }
            }
        }
        
        /*   for(Case caseRecord: scope){
String sub=caseRecord.Subject.toLowerCase();
Pattern regex = Pattern.compile('\\(ref:in:(\\d+)\\)');
Matcher matcher = regex.matcher(sub);

String incNumber;
if (matcher.find()) 
{    
incNumber= matcher.group(1);  
if(incNumber!=null && casetoIncidentId.get(incNumber) !=null)
{
System.debug('Incident nUmber::'+casetoIncidentId.get(incNumber));
recordId = caseRecord.Id;
caseMap.put(recordId, caseRecord);
// Extract the number found and store in a string
EmailMessage email = new EmailMessage();
email.ParentId = casetoIncidentId.get(incNumber);
email.Subject = caseRecord.Subject;
email.TextBody = caseRecord.Description;
email.FromName = caseRecord.SuppliedEmail;
email.MessageDate = caseRecord.CreatedDate;
email.Incoming=true;
createEmailFromCase.add(email);
}
}

}

for(Case caseRecord: scope){
String sub=caseRecord.Subject.toLowerCase();
Pattern regex = Pattern.compile('\\(ref:in:(\\d+)\\)');
Matcher matcher = regex.matcher(sub);

String casenumber;
if (matcher.find()) 
{    
casenumber= matcher.group(1);  
if(casenumber!=null && casenumberTocaseId.get(casenumber) !=null)
{
System.debug('Incident nUmber::'+casenumberTocaseId.get(casenumber));
recordId = caseRecord.Id;
caseMap.put(recordId, caseRecord);
// Extract the number found and store in a string
EmailMessage email = new EmailMessage();
email.ParentId = casenumberTocaseId.get(casenumber);
email.Subject = caseRecord.Subject;
email.TextBody = caseRecord.Description;
email.FromName = caseRecord.SuppliedEmail;
email.MessageDate = caseRecord.CreatedDate;
email.Incoming=true;
createEmailFromCase.add(email);
}
}

} */
        
        Map<Id, Database.SaveResult> caseRecordIdToSaveResult = new Map<Id, Database.SaveResult>();
        
        if (!createEmailFromCase.isEmpty()) {
            //update scope;
            Database.SaveResult[] newCaseHisSave = Database.insert(createEmailFromCase, false);
            List<String> allErrors = new List<String>();
            List<String> errorContexts = new List<String>();
            Integer errorCounter=0;
            String listOfErrorMessagesHis = '';
            // Iterate through each returned result
            for (Integer i = 0; i < newCaseHisSave.size(); i++) {
                Database.SaveResult srList = newCaseHisSave[i];
                counterForErrorMessages++; // Increment counter regardless of success or failure
                if (srList.isSuccess()) {
                    // If the operation was successful, add the corresponding case record ID and SaveResult to the map
                   // Check if i is within the bounds of scope
                        caseRecordIdToSaveResult.put(scope[i].Id, srList);
                    
                    
                } else {
                    for (Database.Error err : srList.getErrors()) {
                        errorContexts.add(err.getMessage());
                        errorCounter++;
                        // Instead of using recordId, use the case record ID associated with the current SaveResult
                        listOfErrorMessagesHis = 'recordId : ' + scope[i].Id + ': {"errorMesage from RestrictEmailToCase" : ' + err.getFields() + ' : ' + err.getMessage() + '"}';
                    }
                    allErrors.add(listOfErrorMessagesHis);
                }
            }
            if (!allErrors.isEmpty()) {
                String stringValues = JSON.serializePretty(allErrors);
                String removeSlash = stringValues.replaceAll('\\\\', '').replaceAll('\\"', '"').replaceAll('\\{', '{').replaceAll('\\}', '}');
                VLSF_ExceptionLog.ErrorLogMigration(JSON.serialize(errorContexts), JSON.serialize(allErrors), errorCounter, 'Delete Case');
            }
        }
        
        for (Id caseId : caseRecordIdToSaveResult.keySet()) {
            //caselistToDelete.add(caseMap.get(caseId));
            Case caseToDelete = caseMap.get(caseId);
            if (caseToDelete != null) {
                caselistToDelete.add(caseToDelete);
            }
        }
        if (!caselistToDelete.isEmpty()) {
            Delete caselistToDelete;
        }
    }
    public void finish(Database.BatchableContext bc) 
    {
        System.debug('Batch job finished.');
    } 
}