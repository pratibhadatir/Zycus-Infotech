@isTest
public class SLAOLATriggerHandlerTest {
    
    /*@istest
    static void setup() {
        // Create test data
        // Create test Milestone Types
        MilestoneType mt = new MilestoneType(
            Name = 'Test Milestone Type'
        );
        insert mt;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'testuser', Email='testuser@example.com', EmailEncodingKey='UTF-8',
                          FirstName='Test', LastName='User', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles',
                          UserName='testuser123045f@example.com');
        insert u;
        // Create account
        
    }
    
    @isTest(seeAllData=true)
    static void testAfterInsert() {
        Account acc = new Account(Name='Test Account 1',BillingCountry = 'India', 
                                  BillingState = 'Delhi',SLA_Type__c='Standard', Type='Customer');
        insert acc;
        
        // Create contact
        Contact con = new Contact(FirstName='John', LastName='Doe', AccountId=acc.Id);
        insert con;
        
        // Create entitlement
        Entitlement ent = new Entitlement(Name='Test Entitlement', AccountId=acc.Id, StartDate=Date.today(),
                                          EndDate=Date.today().addYears(1));
        insert ent;
        
        // Link entitlement process
        SlaProcess sla = [SELECT Id FROM SlaProcess WHERE NameNorm='standard process_v11' LIMIT 1];
        ent.SlaProcessId = sla.Id;
        update ent;
        system.debug('sla:::'+sla);
        system.debug('ent:::'+ent);
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 10; i++) {
            Case c = new Case(
                Subject = 'Test Case ' + i,
                Status = 'New',
                //AccountId = acc.Id,
                //VLSF_Priority__c = 'P1',
                VLSF_Incident_Type__c = 'Incident',
                VLSF_Team__c='Tech Support',
                VLSF_Sub_Team__c = 'Tech-Support',
                EntitlementId = ent.Id
            );
            cases.add(c);
        }
        
        Case testCase = new Case(
            Subject = 'Test Case',
            VLSF_Priority__c = 'P1',
            AccountId = acc.Id,
            VLSF_Incident_Type__c = 'Incident', // Assuming Incident_Type__c is the API name of the Incident Type field
            VLSF_FRT_Completed__c = false, // Assuming FRT_Completed__c is the API name of the FRT Completed field
            Status = 'New', // Status not equal to 'Closed'
            SuppliedEmail = 'valid.email@example.com',
            EntitlementId = ent.Id
        );
        cases.add(testCase);
        
        List<Case> newCases = new List<Case>();
        
        Test.startTest();
        insert cases;
        system.debug('cases:::'+cases);
        List<MilestoneType> milestonesType = [SELECT Id, Name FROM MilestoneType WHERE Name = 'Test Milestone Type'];
        system.debug('MilestoneType:::'+milestonesType);
        List<CaseMilestone> milestones = [SELECT Id, MilestoneTypeId FROM CaseMilestone WHERE CaseId = :cases];
        system.debug('CaseMilestone:::'+milestones);
        System.assert(milestones.size() > 0, 'Milestones should be created for the case.');
        SLAOLATriggerHandler.handleCases(cases);
        Test.stopTest();
        
        // Assertions to validate the expected outcome
        // Add appropriate assertions here to validate the behavior
    }
    
    @isTest(seeAllData=true)
    static void testUpdateMilestones() {
         Account acc = new Account(Name='Test Account 1',BillingCountry = 'India', 
                                  BillingState = 'Delhi',SLA_Type__c='Standard', Type='Customer');
        insert acc;
        
        // Create contact
        Contact con = new Contact(FirstName='John', LastName='Doe', AccountId=acc.Id);
        insert con;
        
        // Create entitlement
        Entitlement ent = new Entitlement(Name='Test Entitlement', AccountId=acc.Id, StartDate=Date.today(),
                                          EndDate=Date.today().addYears(1));
        insert ent;
        
        // Link entitlement process
        SlaProcess sla = [SELECT Id FROM SlaProcess WHERE NameNorm='standard process_v11' LIMIT 1];
        ent.SlaProcessId = sla.Id;
        update ent;
        system.debug('sla:::'+sla);
        system.debug('ent:::'+ent);

        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 10; i++) {
            Case c = new Case(
                Subject = 'Test Case ' + i,
                Status = 'New',
                //AccountId = acc.Id,
                //VLSF_Priority__c = 'P1',
                VLSF_Incident_Type__c = 'Incident',
                VLSF_Team__c='Tech Support',
                VLSF_Sub_Team__c = 'Tech-Support',
                EntitlementId = ent.Id
            );
            cases.add(c);
        }
        
        Case testCase = new Case(
            Subject = 'Test Case',
            VLSF_Priority__c = 'P1',
            AccountId = acc.Id,
            VLSF_Incident_Type__c = 'Incident', // Assuming Incident_Type__c is the API name of the Incident Type field
            VLSF_FRT_Completed__c = false, // Assuming FRT_Completed__c is the API name of the FRT Completed field
            Status = 'New', // Status not equal to 'Closed'
            SuppliedEmail = 'valid.email@example.com',
            EntitlementId = ent.Id
        );
        cases.add(testCase);
        // Retrieve test data
        Set<Id> caseIds = new Set<Id>();
        for (Case c : cases) {
            caseIds.add(c.Id);
        }
        
        // Call the method to test
        Test.startTest();
        SLAOLATriggerHandler.updateMilestones(caseIds);
        Test.stopTest();
        
        // Verify the results
        List<VLSF_Milestones__c> milestones = [SELECT Id FROM VLSF_Milestones__c];
        //System.assertEquals(10, milestones.size(), 'Expected 10 milestones to be created');
    }
    
    @isTest(seeAllData=true)
    static void testUpdateWorkOrderMilestones() {
        // Retrieve test data
        Account acc = new Account(Name='Test Account 1',BillingCountry = 'India', 
                                  BillingState = 'Delhi',SLA_Type__c='Standard', Type='Customer');
        insert acc;
        
        // Create contact
        Contact con = new Contact(FirstName='John', LastName='Doe', AccountId=acc.Id);
        insert con;
        
        // Create entitlement
        Entitlement ent = new Entitlement(Name='Test Entitlement', AccountId=acc.Id, StartDate=Date.today(),
                                          EndDate=Date.today().addYears(1));
        insert ent;
        
        // Link entitlement process
        SlaProcess sla = [SELECT Id FROM SlaProcess WHERE NameNorm='standard process_v11' LIMIT 1];
        ent.SlaProcessId = sla.Id;
        update ent;
        system.debug('sla:::'+sla);
        system.debug('ent:::'+ent);
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 10; i++) {
            Case c = new Case(
                Subject = 'Test Case ' + i,
                Status = 'New',
                //AccountId = acc.Id,
                //VLSF_Priority__c = 'P1',
                VLSF_Incident_Type__c = 'Incident',
                VLSF_Team__c='Tech Support',
                VLSF_Sub_Team__c = 'Tech-Support',
                EntitlementId = ent.Id
            );
            cases.add(c);
        }
         Case testCase = new Case(
            Subject = 'Test Case',
            VLSF_Priority__c = 'P1',
            AccountId = acc.Id,
            VLSF_Incident_Type__c = 'Incident', // Assuming Incident_Type__c is the API name of the Incident Type field
            VLSF_FRT_Completed__c = false, // Assuming FRT_Completed__c is the API name of the FRT Completed field
            Status = 'New', // Status not equal to 'Closed'
            SuppliedEmail = 'valid.email@example.com',
            EntitlementId = ent.Id
        );
        cases.add(testCase);
        
        // Create test WorkOrder linked to the Case
        
        // Call the method to test
        Test.startTest();
        insert cases;
        Set<Id> caseIds = new Set<Id>();
        List<WorkOrder> workOrders = new List<WorkOrder>();
        for (Case c : cases) {
            caseIds.add(c.Id);
            WorkOrder testWO = new WorkOrder(
                CaseId = c.Id,
                VLSF_Assigned_To__c = 'Test Assigned To',
                VLSF_Sub_Team__c = 'SRE'
            );
            workOrders.add(testWO);
        }
        insert workOrders;
        System.debug('workOrders List::'+workOrders);        
        List<EntityMilestone> em = [Select Id,MilestoneType.Name,ParentEntityId, CompletionDate, ElapsedTimeInDays, ElapsedTimeInHrs, ElapsedTimeInMins, IsCompleted, IsViolated, StartDate, TargetDate, TargetResponseInDays, TargetResponseInHrs, TargetResponseInMins, TimeRemainingInDays, TimeRemainingInMins, TimeSinceTargetInDays, TimeSinceTargetInHrs, TimeSinceTargetInMins From EntityMilestone  Where ParentEntityId IN :caseIds];
        System.debug('Entity Milestones::'+em);
        SLAOLATriggerHandler.updateWorkOrderMilestones(caseIds);
        Test.stopTest();
        
        // Verify the results
        List<VLSF_Milestones__c> milestones = [SELECT Id FROM VLSF_Milestones__c];
        //System.assertEquals(10, milestones.size(), 'Expected 10 milestones to be created');*/
    }