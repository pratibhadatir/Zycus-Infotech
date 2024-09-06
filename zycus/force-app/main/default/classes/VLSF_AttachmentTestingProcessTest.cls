@isTest
public class VLSF_AttachmentTestingProcessTest {
    @testSetup
    static void setup() {
        // Create a custom setting record for Migration_Field_Mapping__mdt
        
        List<BMCServiceDesk__Incident__c> incidents =  VLSF_TestDataFactory.createTestIncidentData();
        
        // Create test Cases linked to Incidents
        List<Case> cases = new List<Case>();
        for (BMCServiceDesk__Incident__c incident : incidents) {
            Case caseRec = new Case(
                VLSF_Link_Incident__c = incident.Id,
                Status = 'New'
            );
            cases.add(caseRec);
        }
        insert cases;
        
        // Create test Attachments for Incidents
        List<Attachment> attachments = new List<Attachment>();
        for (BMCServiceDesk__Incident__c incident : incidents) {
            Attachment att = new Attachment(
                Name = 'TestFile_' + incident.Id + '.txt',
                Body = Blob.valueOf('This is a test file content for ' + incident.Id),
                ParentId = incident.Id
            );
            attachments.add(att);
        }
        insert attachments;
        
        // Create existing ContentDocument and ContentVersion
        ContentVersion cv = new ContentVersion(
            Title = attachments[0].Name,
            PathOnClient = attachments[0].Name,
            VersionData = attachments[0].Body,
            IsMajorVersion = true
        );
        
        insert cv;
        
        ContentVersion contentVer = [Select Id, ContentDocumentId from ContentVersion WHERE Id=:cv.Id LIMIT 1];
        
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId = contentVer.ContentDocumentId,
            LinkedEntityId = cases[0].Id,
            ShareType = 'I',
            Visibility = 'AllUsers'
        ); 
        insert cdl;
    }
    
    @isTest
    static void testBatch() {
        Test.startTest();
        
        // Initialize the batch
        VLSF_AttachmentTestingProcess batch = new VLSF_AttachmentTestingProcess();
        
        // Execute the batch
        Database.executeBatch(batch, 10);
        
        Test.stopTest();
        
    }
}