@isTest (seeAllData=true)
public class SLAOLATriggerTest {
    
    @isTest
    static void testAfterInsert() {
        Account acc = new Account(Name='Test Account 1',BillingCountry = 'India', 
                                  BillingState = 'Delhi',SLA_Type__c='Standard', Type='Customer');
        insert acc;
        
        // Create contact
        Contact con = new Contact(FirstName='John', LastName='Doe', AccountId=acc.Id);
        insert con;
        
        // Create entitlement
        Entitlement ent = new Entitlement(Name='Test Entitlement', AccountId=acc.Id, StartDate=Date.valueof(System.now().addDays(-2)),
                                          EndDate=Date.valueof(System.now().addYears(2)));
        insert ent;
        
        // Link entitlement process
        SlaProcess sla = [SELECT Id,Name FROM SlaProcess WHERE Name='Standard Process' AND isActive=TRUE LIMIT 1];
        ent.SlaProcessId = sla.Id;
        update ent;
        
        system.debug('sla:::'+sla);
        system.debug('ent:::'+ent);
        system.debug('SlaProcessId==>'+ent.SlaProcessId);
            
        Case testCase = new Case(
            Subject = 'Test Case',
            Priority = 'P1',
            AccountId = acc.Id,
            VLSF_Incident_Type__c = 'Incident', // Assuming Incident_Type__c is the API name of the Incident Type field
            VLSF_FRT_Completed__c = false, // Assuming FRT_Completed__c is the API name of the FRT Completed field
            Status = 'New', // Status not equal to 'Closed'
            SuppliedEmail = 'valid.email@example.com',
            EntitlementId = ent.Id
            //slaStartDate=system.now()
        );
        insert testCase;
        System.debug('MyDebug :'+testCase.Id);
        
		List<CaseMilestone> caseMilestones = [Select Id from CaseMilestone WHERE CaseId =:testCase.Id];
		System.debug('MyDebug :'+caseMilestones[0].Id);
        
        Entitlement entOLA = new Entitlement(Name='Certinal', AccountId=acc.Id, StartDate=Date.valueof(System.now().addDays(-2)),
                                          EndDate=Date.valueof(System.now().addYears(2)));
        insert entOLA;
        
        // Link entitlement process
        SlaProcess ola = [SELECT Id,Name FROM SlaProcess WHERE Name='Certinal' AND isActive=TRUE LIMIT 1];
        entOLA.SlaProcessId = ola.Id;
        update entOLA;
        
       WorkOrder testWorkOrder = new WorkOrder(
            Priority = 'P1', 
            VLSF_Incident_Type__c = 'Incident', 
           VLSF_Sub_Team__c = 'Certinal',
            VLSF_Case_Closed__c = FALSE,
            VLSF_Approved__c = TRUE,
            EntitlementId = entOLA.Id,
           
            CaseId = testCase.Id
        );
        insert testWorkOrder;
        
        Set<Id> csId=new Set<Id>();
        csId.add(testCase.Id);
        test.startTest();
         SLAOLATriggerHandler.updateMilestones(csId);
        SLAOLATriggerHandler.updateWorkOrderMilestones(csId);
        test.stopTest();
    }
    
    @isTest
    static void testBeforeUpdate() {
        Account acc = new Account(Name='Test Account 2', BillingCountry = 'India', 
                                  BillingState = 'Delhi', SLA_Type__c='Standard', Type='Customer');
        insert acc;
        
        Case testCase = new Case(
            Subject = 'Test Case Before Update',
            Priority = 'P1',
            AccountId = acc.Id,
            VLSF_Incident_Type__c = 'Incident',
            VLSF_FRT_Completed__c = false,
            Status = 'New',
            SuppliedEmail = 'valid.email@example.com'
        );
        insert testCase;
        
        // Update case to trigger before update
        testCase.VLSF_Priority__c = 'P2';
        update testCase;
        
        // Verify that the SLAOLATriggerHandler.handleCases was called
        List<Case> priorityChangedCases = [SELECT Id, VLSF_Priority__c FROM Case WHERE Id = :testCase.Id];
        System.assertEquals('P2', priorityChangedCases[0].VLSF_Priority__c);
    }
    
    @isTest
    static void testAfterUpdate() {
        Account acc = new Account(Name='Test Account 3', BillingCountry = 'India', 
                                  BillingState = 'Delhi', SLA_Type__c='Standard', Type='Customer');
        insert acc;
        
        Case testCase = new Case(
            Subject = 'Test Case After Update',
            Priority = 'P1',
            AccountId = acc.Id,
            VLSF_Incident_Type__c = 'Incident',
            VLSF_FRT_Completed__c = false,
            Status = 'New',
            SuppliedEmail = 'valid.email@example.com'
        );
        insert testCase;
        
        //Resolve Case
        testCase.VLSF_Resolution__c = 'NA';
        testCase.VLSF_Workaround_description__c = 'NA';
        testCase.VLSF_Issue_escaped__c = 'Implementation';
        testCase.VLSF_Root_Cause_analysis__c = 'NA';
        testCase.Reason_KA_not_attached__c = 'The knowledge article may not directly address the issue or question raised in the case. Attaching irrelevant articles can confuse users and waste their time.';
        testCase.VLSF_Resolution_Code__c = 'Resolved - Customer Confirmation awaited';
        testCase.Status = 'Resolved';
        update testCase;
        
        // Update case to trigger after update
        testCase.Status = 'Closed';
        update testCase;
        
        
        // Verify that the SLAOLATriggerHandler.handleCases was called
        List<Case> closedCases = [SELECT Id, Status, VLSF_FRT_Completed__c, VLSF_Sub_Team__c FROM Case WHERE Id = :testCase.Id];
        System.assertEquals('Closed', closedCases[0].Status);
            
    }
    
    
}