@isTest
public class ActivityTimelineControllerTest {
    @testSetup
    static void setupTestData() {
        // Create test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Create test contacts
        Contact testContact1 = new Contact(LastName = 'Test Contact 1', AccountId = testAccount.Id);
        Contact testContact2 = new Contact(LastName = 'Test Contact 2', AccountId = testAccount.Id);
        insert new List<Contact>{testContact1, testContact2};
        
        // Create test opportunities
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity', 
            AccountId = testAccount.Id, 
            StageName = 'Prospecting', 
            CloseDate = Date.today()
        );
        insert testOpportunity;
        
        // Create test events
        Event testEvent1 = new Event(
            Subject = 'Test Event 1',
            WhatId = testAccount.Id,
            WhoId = testContact1.Id,
            StartDateTime = DateTime.now().addDays(-10),
            EndDateTime = DateTime.now().addDays(-10).addHours(1),
            DurationInMinutes = 60,
            Sub_Category__c = 'Test Sub Category'
        );
        Event testEvent2 = new Event(
            Subject = 'Test Event 2',
            WhatId = testOpportunity.Id,
            WhoId = testContact2.Id,
            StartDateTime = DateTime.now().addDays(-20),
            EndDateTime = DateTime.now().addDays(-20).addHours(1),
            DurationInMinutes = 60,
            Sub_Category__c = 'Test Sub Category'
        );
        insert new List<Event>{testEvent1, testEvent2};
        
        // Create test tasks
        Task testTask1 = new Task(
            Subject = 'Test Task 1',
            WhatId = testAccount.Id,
            WhoId = testContact1.Id,
            ActivityDate = Date.today().addDays(-5),
            Status = 'Not Started',
            Priority = 'Normal',
            Sub_Category__c = 'Test Sub Category'
        );
        Task testTask2 = new Task(
            Subject = 'Test Task 2',
            WhatId = testOpportunity.Id,
            WhoId = testContact2.Id,
            ActivityDate = Date.today().addDays(-15),
            Status = 'Not Started',
            Priority = 'Normal',
            Sub_Category__c = 'Test Sub Category'
        );
        insert new List<Task>{testTask1, testTask2};
    }
    
    @isTest
    static void testLoadActivities() {
        // Retrieve the test account
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        // Create the standard controller and the extension
        ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        ActivityTimelineController controller = new ActivityTimelineController(stdController);
        
        // Call the loadActivities method
        Test.startTest();
        controller.loadActivities();
        Test.stopTest();
        
        // Verify the event activities
        System.assertEquals(2, controller.eventActivities.size(), 'Event activities count should be 2');
        System.assert(controller.eventActivities[0].Id != null, 'Event activity 1 should have an ID');
        System.assert(controller.eventActivities[1].Id != null, 'Event activity 2 should have an ID');
        
        // Verify the task activities
        System.assertEquals(2, controller.taskActivities.size(), 'Task activities count should be 2');
        System.assert(controller.taskActivities[0].Id != null, 'Task activity 1 should have an ID');
        System.assert(controller.taskActivities[1].Id != null, 'Task activity 2 should have an ID');
        
        // Verify the formula fields
        for (Event event : controller.eventActivities) {
            System.assert(event.Gold_Email_Zycus__c != null, 'Event Gold_Email_Zycus__c should not be null');
            System.assertEquals('Zycus', event.Assigned_Role__c, 'Event Assigned_Role__c should be Zycus');
        }
        
        for (Task task : controller.taskActivities) {
            System.assert(task.Gold_Email_Zycus__c != null, 'Task Gold_Email_Zycus__c should not be null');
            System.assertEquals('Zycus', task.Assigned_Role__c, 'Task Assigned_Role__c should be Zycus');
        }
    }
}