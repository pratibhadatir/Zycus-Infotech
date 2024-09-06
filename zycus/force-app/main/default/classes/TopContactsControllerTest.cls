@isTest
public class TopContactsControllerTest {
    static testMethod void testLoadTopContacts() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact1 = new Contact(
            LastName = 'Smith',
            AccountId = testAccount.Id,
            Title = 'Manager',
            Primary_Contact__c = '1' // Numeric representation for "Yes"
        );

        Contact testContact2 = new Contact(
            LastName = 'Johnson',
            AccountId = testAccount.Id,
            Title = 'Director',
            Primary_Contact__c = '2' // Numeric representation for "No"
        );

        insert new List<Contact>{testContact1, testContact2};

        Task task1 = new Task(
            WhatId = testAccount.Id,
            WhoId = testContact1.Id,
            ActivityDate = System.today(),
            Status = 'Completed'            
        );

        Task task2 = new Task(
            WhatId = testAccount.Id,
            WhoId = testContact2.Id,
            ActivityDate = System.today(),
            Status = 'Completed'
        );

        insert new List<Task>{task1, task2};

        // Test the controller
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        TopContactsController controller = new TopContactsController(stdController);
        Test.stopTest();

        // Assertions to verify the correct behavior
        System.assert(controller.topContacts.size() == 2, 'There should be two contacts in the list.');
        System.assertEquals(testContact1.Id, controller.topContacts[0].contactId, 'The contact ID should match.');
        System.assertEquals('1', controller.topContacts[0].isPrimary, 'The primary status should match.'); // Adjust to expect '1'
        System.assertEquals(1, controller.topContacts[0].activityCount, 'The activity count should be 1.');
    }
}