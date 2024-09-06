@isTest
public class VLSF_MigrateProblemTest{
    public static testMethod void testBatchExecution(){
        // Create test data for BMCServiceDesk__Problem__c
        BMCServiceDesk__Status__c sta = new BMCServiceDesk__Status__c();
        sta.Name = 'RESOLVED';
        sta.BMCServiceDesk__appliesToProblem__c = true;
        sta.BMCServiceDesk__inactive__c = false;
        Insert sta;
        BMCServiceDesk__Status__c resDup = new BMCServiceDesk__Status__c();
        resDup.Name = 'Resolved Duplicate';
        resDup.BMCServiceDesk__appliesToProblem__c = true;
        resDup.BMCServiceDesk__inactive__c = false;
        Insert resDup;
        BMCServiceDesk__Status__c under = new BMCServiceDesk__Status__c();
        under.Name = 'Under Monitoring';
        under.BMCServiceDesk__appliesToProblem__c = true;
        under.BMCServiceDesk__inactive__c = false;
        Insert under;
        BMCServiceDesk__Status__c rca = new BMCServiceDesk__Status__c();
        rca.Name = 'RCA & Corrective-Action Provided';
        rca.BMCServiceDesk__appliesToProblem__c = true;
        rca.BMCServiceDesk__inactive__c = false;
        Insert rca;
        
        Profile profile = [SELECT Id
                           from Profile
                           Where Name = 'Service Desk Staff']; 
        User testUser = new User(
            Alias = 'tes2w1', 
            Email = 'testuser1@example.com', 
            EmailEncodingKey = 'UTF-8', 
            LastName = 'Test', 
            LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', 
            ProfileId = profile.Id, 
            BMCServiceDesk__IsStaffUser__c = true, 
            TimeZoneSidKey = 'America/Los_Angeles', 
            UserName = 'testusqrprob_mdigra321@example.com'
        );
        insert testUser;
       
        List<BMCServiceDesk__Problem__c> probliemTestList = new List<sObject>();
        BMCServiceDesk__Problem__c prob4 = new BMCServiceDesk__Problem__c();
        prob4.BMCServiceDesk__Problem_Description__c = 'Unable to login to supplier portal';
        prob4.BMCServiceDesk__Problem_Resolution__c = 'Resolution';
        prob4.BMCServiceDesk__Problem_Source__c = 'Client';
        prob4.BMCServiceDesk__FKStaff__c = testUser.Id;
        prob4.Severity__c = 'Medium';
        prob4.TeamT__c = 'PEG';
        prob4.Subject__c = '';
        prob4.BMCServiceDesk__FKStatus__c = resDup.Id;
        insert prob4;
        BMCServiceDesk__Problem__c prob3 = new BMCServiceDesk__Problem__c();
        prob3.BMCServiceDesk__Problem_Description__c = 'Unable to login to supplier portal';
        prob3.BMCServiceDesk__Problem_Resolution__c = 'Resolution';
        prob3.BMCServiceDesk__Problem_Source__c = 'Client';
        prob3.BMCServiceDesk__FKStaff__c = testUser.Id;
        prob3.Severity__c = 'Medium';
        prob3.TeamT__c = 'PEG';
        prob3.Subject__c = '';
        prob3.BMCServiceDesk__FKStatus__c = under.Id;
        insert prob3;
        BMCServiceDesk__Problem__c prob1 = new BMCServiceDesk__Problem__c();
        prob1.BMCServiceDesk__Problem_Description__c = 'Unable to login to supplier portal';
        prob1.BMCServiceDesk__Problem_Resolution__c = 'Resolution';
        prob1.BMCServiceDesk__Problem_Source__c = 'Client';
        prob1.BMCServiceDesk__FKStaff__c = testUser.Id;
        prob1.Severity__c = 'Medium';
        prob1.TeamT__c = 'PEG';
        prob1.Subject__c = '';
        prob1.BMCServiceDesk__FKStatus__c = resDup.Id;
        insert prob1;
        
        BMCServiceDesk__Problem__c prob2 = new BMCServiceDesk__Problem__c();
        prob2.BMCServiceDesk__Problem_Description__c = 'Unable to login to supplier portal3';
        prob2.BMCServiceDesk__Problem_Resolution__c = 'Resolution';
        prob2.BMCServiceDesk__Problem_Source__c = 'Client';
        prob2.BMCServiceDesk__FKStaff__c = testUser.Id;
        prob2.Severity__c = 'Medium';
        prob2.TeamT__c = 'PEG';
        prob2.Assigned_To__c='Jimit Shah';
        prob2.Subject__c = 'New issue has been generated';
        prob2.BMCServiceDesk__FKStatus__c = sta.Id;
       insert prob2;

        
        // Test batch execution
        Test.startTest();
        Database.executeBatch(new VLSF_MigrateProblem());
        Test.stopTest();
        
    }
    
}