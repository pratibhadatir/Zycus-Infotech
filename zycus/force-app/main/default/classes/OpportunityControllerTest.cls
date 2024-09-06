@isTest
private class OpportunityControllerTest {
    @isTest static void testConstructor() {
        // Create test Opportunity
        Opportunity testOpp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today());
        insert testOpp;

        // Create a new page reference and assign the Opportunity Id as a parameter
        ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
        OpportunityController controller = new OpportunityController(sc);

        // Verify that the opportunity is correctly set
        System.assertEquals(testOpp.Id, controller.opportunity.Id);
        // Verify that edit mode is set to false initially
        System.assertEquals(false, controller.editMode);
    }

    @isTest static void testToggleEdit() {
        // Create test Opportunity
        Opportunity testOpp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today());
        insert testOpp;

        ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
        OpportunityController controller = new OpportunityController(sc);

        // Call toggleEdit method
        controller.toggleEdit();

        // Verify that edit mode is set to true after calling toggleEdit
        System.assertEquals(true, controller.editMode);
    }

    @isTest static void testCancel() {
        // Create test Opportunity
        Opportunity testOpp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today());
        insert testOpp;

        ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
        OpportunityController controller = new OpportunityController(sc);

        // Set edit mode to true
        controller.toggleEdit();

        // Call cancel method
        controller.cancel();

        // Verify that edit mode is set to false after calling cancel
        System.assertEquals(false, controller.editMode);
    }

    @isTest static void testSave() {
        // Create test Opportunity
        Opportunity testOpp = new Opportunity(Name = 'Test Opportunity', StageName = 'Qualified', CloseDate = Date.today());
        insert testOpp;

        ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
        OpportunityController controller = new OpportunityController(sc);

        // Call save method
        controller.save();

        // Verify that edit mode is set to false after calling save
        System.assertEquals(false, controller.editMode);
    }
}