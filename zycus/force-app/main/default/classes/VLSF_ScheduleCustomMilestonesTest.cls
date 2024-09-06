@IsTest
private class VLSF_ScheduleCustomMilestonesTest {

    @TestSetup
    static void setup() {
        // Insert test data required for batch classes
        // Example: Insert Cases and Work Orders with milestones
        
        List<Case> cases = new List<Case>();
        List<WorkOrder> workOrders = new List<WorkOrder>();
        
        for(Integer i = 0; i < 10; i++) {
            cases.add(new Case(Subject = 'Test Case ' + i, Status = 'New'));
            workOrders.add(new WorkOrder(Description = 'Test Work Order ' + i, Status = 'New'));
        }
        
        insert cases;
        insert workOrders;
    }

    @IsTest
    static void testExecuteMethod() {
        // Create an instance of the Schedulable class
        VLSF_ScheduleCustomMilestones schedulableInstance = new VLSF_ScheduleCustomMilestones();
        
        // Mock the SchedulableContext
        Test.startTest();
        String jobId = System.schedule('Test VLSF_ScheduleCustomMilestones Job', '0 0 0 15 8 ?', schedulableInstance);
        Test.stopTest();

        // Assert that the scheduled job was created successfully
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
                          FROM CronTrigger WHERE Id = :jobId];
        
        System.assertEquals('0 0 0 15 8 ?', ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertNotEquals(null, ct.NextFireTime);

        // Verify the batch jobs were executed
        List<AsyncApexJob> batchJobs = [SELECT Id, Status, JobItemsProcessed FROM AsyncApexJob WHERE JobType = 'BatchApex' AND Status = 'Completed'];
        System.assertEquals(2, batchJobs.size());
        for (AsyncApexJob job : batchJobs) {
            System.assertEquals('Completed', job.Status);
            System.assert(job.JobItemsProcessed > 0, 'JobItemsProcessed should be greater than 0');
        }
    }
}