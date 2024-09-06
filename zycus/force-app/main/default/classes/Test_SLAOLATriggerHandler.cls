@isTest(seeAllData=true)
public class Test_SLAOLATriggerHandler {

    @isTest
    static void testUpdateMilestonesMethod() {
        
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
        
        Set<Id> csId=new Set<Id>();
        csId.add(testCase.Id);
        test.startTest();
        SLAOLATriggerHandler.updateMilestones(csId);
        test.stopTest();
    }
}