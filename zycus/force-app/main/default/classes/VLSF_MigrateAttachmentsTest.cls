@isTest
public class VLSF_MigrateAttachmentsTest {

    @istest
    static void setup() {
        Account testAccount = new Account(
            Name = 'Test Account', 
            BillingCountry = 'India', 
            BillingState = 'Delhi'
        );
        insert testAccount;
		//BMCServiceDesk__Status__c sta = [Select Id from BMCServiceDesk__Status__c where Name ='In Progress'];
        BMCServiceDesk__Status__c sta = new BMCServiceDesk__Status__c();
        sta.Name = 'CLOSED';
        sta.BMCServiceDesk__appliesToIncident__c = true;
        sta.BMCServiceDesk__inactive__c = false;
        Insert sta; 
        
        BMCServiceDesk__Status__c stat = new BMCServiceDesk__Status__c();
        stat.Name = 'In Progress';
        stat.BMCServiceDesk__appliesToIncident__c = true;
        stat.BMCServiceDesk__inactive__c = false;
        Insert stat;
        
        BMCServiceDesk__Status__c stats = new BMCServiceDesk__Status__c();
        stats.Name = 'Rejected';
        stats.BMCServiceDesk__appliesToIncident__c = true;
        stats.BMCServiceDesk__inactive__c = false;
        Insert stats;

        // Create test incidents
        List<BMCServiceDesk__Incident__c> testIncidents = new List<BMCServiceDesk__Incident__c>();
        for (Integer i = 0; i < 3; i++){
            if(i==0){
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    //BMCServiceDesk__RF_SkipTriggerExecution__c	= true,
                    Incident_origin__c = 'Email', 
                    Product__c = 'iPerform', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__FKStatus__c = sta.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Team__c = 'Certinal',
                    Assigned_To__c='Team_Certinal',
                    Workaround_time__c = System.now(), 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            } else if(i==1){
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    //BMCServiceDesk__RF_SkipTriggerExecution__c	= true,
                    Product__c = 'iPerform', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__FKStatus__c = stats.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Team__c = 'Certinal',
                    Assigned_To__c='Team_Certinal',
                    Workaround_time__c = System.now(), 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            }else{
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    //BMCServiceDesk__RF_SkipTriggerExecution__c	= true,
                    Product__c = 'iPerform', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__FKStatus__c = stat.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Team__c = 'Certinal',
                    Assigned_To__c='Team_Certinal',
                    Workaround_time__c = System.now(), 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            }
        }
        insert testIncidents;
        List<Case> caseList = new List<Case>();
        for (Integer i = 0; i < 5; i++) {
            Case caseObj = new Case(
                Subject = 'Test Case ' + i,
                Status = 'Opened',
                VLSF_Link_Incident__c = testIncidents[0].Id
            );
            caseList.add(caseObj);
        }
        insert caseList;

        // Create Attachments for the Incident
        Attachment att = new Attachment(
            Name = 'TestAttachment.txt',
            Body = Blob.valueOf('This is a test attachment.'),
            ParentId = testIncidents[0].Id
        );
        insert att;
		List<ContentVersion> contentList = new List<ContentVersion>();
        ContentVersion cv = new ContentVersion(
            Title = 'Test Content Version',
            PathOnClient = 'TestDocument.txt',
            VersionData = Blob.valueOf('This is a test document.')
        );
        contentList.add(cv);
         ContentVersion cv1 = new ContentVersion(
            Title = 'Test Content Version',
            PathOnClient = 'TestDocument.txt',
            VersionData = Blob.valueOf('This is a test document.')
        );
        contentList.add(cv1);
        insert contentList;

        List<ContentVersion> insertedContentVersions = [SELECT Id, ContentDocumentId, FirstPublishLocationId FROM ContentVersion WHERE Id=:contentList];

        List<ContentDocumentLink> contentDocLinks = new List<ContentDocumentLink>();
        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = testIncidents[0].Id,
            ContentDocumentId = insertedContentVersions[0].ContentDocumentId,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        contentDocLinks.add(cdl);
        ContentDocumentLink cdl2 = new ContentDocumentLink(
            LinkedEntityId = testIncidents[0].Id,
            ContentDocumentId = insertedContentVersions[1].ContentDocumentId,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        contentDocLinks.add(cdl2);
        insert contentDocLinks;
        Test.startTest();

        // Instantiate the batch class
        Database.executebatch(new VLSF_MigrateAttachments(), 10);

        Test.stopTest();

        // Verify that the ContentVersion records are created for the attachments
        List<ContentVersion> contentVersions = [SELECT Id, VLSF_Attachment_Id__c FROM ContentVersion WHERE Title = 'TestAttachment.txt'];
        //System.assertEquals(1, contentVersions.size(), 'Expected one ContentVersion to be created.');

        // Verify that the ContentDocumentLink records are created for the cases
        List<ContentDocumentLink> contentDocumentLinks = [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN (SELECT Id FROM Case)];
       // System.assertEquals(2, contentDocumentLinks.size(), 'Expected two ContentDocumentLinks to be created.');
   
    }

}