public class VLSF_MilestonesScheduledJobHandler {
    public void executeJob(List<WorkOrder> workOrders) {
        // Extract WorkOrder IDs
        Set<Id> workOrderIds = new Set<Id>();
        Set<Id> caseIds = new Set<Id>();
        for (WorkOrder wo : workOrders) {
            workOrderIds.add(wo.Id);
            if (wo.CaseId != null) {
                caseIds.add(wo.CaseId);
            }
        }
        
        // Query the EntityMilestone records related to the WorkOrder IDs
        
        List<EntityMilestone> workOrderMilestones = [SELECT Id,CompletionDate, ElapsedTimeInDays, ElapsedTimeInHrs, ElapsedTimeInMins, 
                                                    IsCompleted, IsDeleted, IsViolated,Name, ParentEntityId,
                                                    StartDate, TargetDate, TargetResponseInDays, TargetResponseInHrs, 
                                                    TargetResponseInMins, TimeRemainingInDays, TimeRemainingInHrs, 
                                                    TimeRemainingInMins, TimeSinceTargetInDays, TimeSinceTargetInHrs, 
                                                    TimeSinceTargetInMins FROM EntityMilestone WHERE ParentEntityId IN :workOrderIds];

        // Query the CaseMilestone records related to the Case IDs

        List<CaseMilestone> caseMilestones = [SELECT Id,CaseId, CompletionDate, ElapsedTimeInDays, ElapsedTimeInHrs, ElapsedTimeInMins, IsCompleted, IsDeleted, 
                                             IsViolated, StartDate, TargetDate, TargetResponseInDays, TargetResponseInHrs, TargetResponseInMins, TimeRemainingInDays, 
                                             TimeRemainingInHrs, TimeRemainingInMins, TimeSinceTargetInDays, TimeSinceTargetInHrs, TimeSinceTargetInMins, MilestoneType.Name from CaseMilestone  
                                              WHERE CaseId IN :caseIds];

      
        
    }
}