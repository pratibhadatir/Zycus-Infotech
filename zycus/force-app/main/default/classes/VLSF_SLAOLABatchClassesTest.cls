@isTest(seeAllData=true)
public class VLSF_SLAOLABatchClassesTest {

    @isTest
    static void testBatchProcesses() {
        // Start test context
        
        
        // Create Account
        Account acc = new Account(Name='Test Account 1', BillingCountry='India', 
                                  BillingState='Delhi', SLA_Type__c='Standard', Type='Customer');
        insert acc;
        
        // Create Contact
        Contact con = new Contact(FirstName='John', LastName='Doe', AccountId=acc.Id);
        insert con;
        
        // Create first Entitlement
        Entitlement ent = new Entitlement(Name='Test Entitlement', AccountId=acc.Id, StartDate=Date.valueOf(System.now().addDays(-2)),
                                          EndDate=Date.valueOf(System.now().addYears(2)));
        insert ent;
        
        // Link entitlement process to the first entitlement
        SlaProcess sla = [SELECT Id, Name FROM SlaProcess WHERE Name='Standard Process' AND isActive=TRUE LIMIT 1];
        ent.SlaProcessId = sla.Id;
        update ent;
        
        // Create Case records
        List<Case> caseList = new List<Case>();
        for (Integer i = 0; i < 100; i++) {
            caseList.add(new Case(Subject='Test Case',
                                  Priority='P1',
                                  AccountId=acc.Id,
                                  VLSF_Incident_Type__c='Incident', 
                                  VLSF_FRT_Completed__c=false,
                                  Status='New',
                                  SuppliedEmail='valid.email@example.com',
                                  EntitlementId=ent.Id));
        }
        database.insert(caseList);

        Test.startTest();
        // Execute Case Milestones Batch
        VLSF_CaseMilestones caseBatch = new VLSF_CaseMilestones();
        Database.executeBatch(caseBatch);
        VLSF_WorkOrderMilestones WorkOrderBatch = new VLSF_WorkOrderMilestones();
        Database.executeBatch(WorkOrderBatch);
        Test.stopTest();
       
       
        
    
    }
}