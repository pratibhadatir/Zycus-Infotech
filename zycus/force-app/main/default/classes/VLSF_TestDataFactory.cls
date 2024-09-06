public class VLSF_TestDataFactory{
    
    Public static Account createTestAccount(){
        Account testAccount = new Account(
            Name = 'Test Account for Incident',
            BillingCountry = 'India',
            BillingState = 'Delhi'
        );
        insert testAccount;
        return testAccount;
    }
    
    public static List<BMCServiceDesk__Incident__c> createTestIncidentData() {

        Account testAcc = createTestAccount();
        
        // Insert BMCServiceDesk__Status__c records
        BMCServiceDesk__Status__c parked2 = new BMCServiceDesk__Status__c(Name = 'Parked', BMCServiceDesk__appliesToIncident__c = true, BMCServiceDesk__inactive__c = false);
        BMCServiceDesk__Status__c sta = new BMCServiceDesk__Status__c(Name = 'CLOSED', BMCServiceDesk__appliesToIncident__c = true, BMCServiceDesk__inactive__c = false);
        BMCServiceDesk__Status__c stats = new BMCServiceDesk__Status__c(Name = 'Rejected', BMCServiceDesk__appliesToIncident__c = true, BMCServiceDesk__inactive__c = false);
        BMCServiceDesk__Status__c parked = new BMCServiceDesk__Status__c(Name = 'Reopen', BMCServiceDesk__appliesToIncident__c = true, BMCServiceDesk__inactive__c = false);
        BMCServiceDesk__Status__c duplicate = new BMCServiceDesk__Status__c(Name = 'Resolved Duplicate', BMCServiceDesk__appliesToIncident__c = true, BMCServiceDesk__inactive__c = false);
        BMCServiceDesk__Status__c resol = new BMCServiceDesk__Status__c(Name = 'Resolved: RM-Partner', BMCServiceDesk__appliesToIncident__c = true, BMCServiceDesk__inactive__c = false);
        BMCServiceDesk__Status__c stat = new BMCServiceDesk__Status__c(Name = 'In Progress', BMCServiceDesk__appliesToIncident__c = true, BMCServiceDesk__inactive__c = false);
        BMCServiceDesk__Status__c resolve = new BMCServiceDesk__Status__c(Name = 'Awaiting Deployment', BMCServiceDesk__appliesToIncident__c = true, BMCServiceDesk__inactive__c = false);
        BMCServiceDesk__Status__c resolv = new BMCServiceDesk__Status__c(Name = 'Resolved', BMCServiceDesk__appliesToIncident__c = true, BMCServiceDesk__inactive__c = false);
        
        insert new List<BMCServiceDesk__Status__c>{parked2, sta, stats, parked, duplicate, resol, stat, resolve, resolv};
            
            // Query all BMCServiceDesk__Status__c records
            List<BMCServiceDesk__Status__c> statuses = [SELECT Id FROM BMCServiceDesk__Status__c WHERE Name IN ('Parked', 'CLOSED', 'Rejected', 'Reopen', 'Resolved Duplicate', 'Resolved: RM-Partner', 'In Progress', 'Awaiting Deployment', 'Resolved')];
        
        // Insert test incidents
        List<BMCServiceDesk__Incident__c> testIncidents = new List<BMCServiceDesk__Incident__c>();
        for (Integer i = 0; i < 9; i++) {
            BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                Subject__c = 'New Problem Check testing ' + i,
                Incident_origin__c = 'Email',
                Product__c = 'iPerform',
                RM_ID__c = 'w3ffecsa',
                QA_status__c = 'Open',
                Region__c = 'Global',
                BMCServiceDesk__IncidentType__c = 'Incident',
                Reported_By__c = 'External',
                BMCServiceDesk__incidentDescription__c = 'Description field value',
                BMCServiceDesk__FKStatus__c = statuses[i].Id, // Use modulus operator to cycle through statuses
                Case_Type__c = 'Bug',
                BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with',
                BMCServiceDesk__incidentResolution__c = 'BMCServiceDesk__incidentResolution__c',
                Workaround_provided__c = 'Yes',
                TeamT__c = 'Certinal',
                Ticket_Flow__c = 5,
                Unassigned_L1__c = System.now(),
                Team__c = 'SRE',
                Issue_escaped__c = 'Implementation',
                Assigned_To__c = 'Team_Certinal',
                Workaround_time__c = System.now(),
                BMCServiceDesk__FKAccount__c = testAcc.Id
            );
            testIncidents.add(testIncident);
        }
        insert testIncidents;
        
        // Return the list of created incidents
        return testIncidents;
    }
    
    
    public static Case createTestCase(String subject, String description){
        Case testCase = new Case();
        testCase.Subject = subject;
        testCase.Description = description;
        insert testCase;
        return testCase;
    }
    
    public static ContentVersion createTestContentVersion(Id linkId){
        if (linkId != null){
            ContentVersion testContent = new ContentVersion(
                Title = 'Test Content ', 
                PathOnClient = '/testfile.txt', 
                FirstPublishLocationId = linkId, 
                VersionData = Blob.valueOf('Test Content Body'), 
                IsMajorVersion = true
            );
            insert testContent;
            return testContent;
        } else{
            ContentVersion testContent = new ContentVersion(
                Title = 'Test Content ', 
                PathOnClient = '/testfile.txt', 
                VersionData = Blob.valueOf('Test Content Body'), 
                IsMajorVersion = true
            );
            insert testContent;
            return testContent;
        }
    }
    
    public static ContentDocumentLink createContentDocumentLink(Id linkedEntityId, Id contentDocumentId){
        ContentDocumentLink testLink = new ContentDocumentLink();
        testLink.LinkedEntityId = linkedEntityId;
        testLink.ContentDocumentId = contentDocumentId;
        insert testLink;
        return testLink;
    }
    
}