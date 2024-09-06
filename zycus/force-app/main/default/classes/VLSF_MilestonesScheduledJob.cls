global class VLSF_MilestonesScheduledJob implements Schedulable {
    global void execute(SchedulableContext sc) {

        // Query the WorkOrder records
        
        List<WorkOrder> workOrders = [SELECT Id, AccountId, CaseId, VLSF_Case_Closed__c, IsStopped, MilestoneStatus, WorkOrderNumber 
                                              FROM WorkOrder 
                                              WHERE VLSF_Case_Closed__c = false];

       
        VLSF_MilestonesScheduledJobHandler handler = new VLSF_MilestonesScheduledJobHandler();
        handler.executeJob(workOrders);
    }
}