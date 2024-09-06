@isTest
private class OpportunityControllerTestB {
    @isTest static void testDeleteContactRoleWithNullId() {
        // Create test Opportunity
        Opportunity testOpp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today());
        insert testOpp;

        ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
        OpportunityController controller = new OpportunityController(sc);

        // Set contactRoleIdToDelete to null
        controller.contactRoleIdToDelete = null;

        // Call deleteContactRole method
        Test.startTest();
        controller.deleteContactRole();
        Test.stopTest();

        // Verify that no contact role deletion is attempted
        // Ensure that no OpportunityContactRole records are deleted
        System.assertEquals(0, [SELECT COUNT() FROM OpportunityContactRole]);
    }

    @isTest static void testDeleteContactRoleWithValidId() {
        // Create test Opportunity
        Opportunity testOpp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today());
        insert testOpp;

        // Create test Contact
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert testContact;

        // Create test OpportunityContactRole with ContactId populated
        OpportunityContactRole testRole = new OpportunityContactRole(OpportunityId = testOpp.Id, Role = 'Decision Maker', ContactId = testContact.Id);
        insert testRole;

        ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
        OpportunityController controller = new OpportunityController(sc);

        // Set contactRoleIdToDelete to the Id of the test contact role
        controller.contactRoleIdToDelete = testRole.Id;

        // Call deleteContactRole method
        Test.startTest();
        controller.deleteContactRole();
        Test.stopTest();

        // Verify that the contact role is deleted
        System.assertEquals(0, [SELECT COUNT() FROM OpportunityContactRole WHERE Id = :testRole.Id]);
    }
}