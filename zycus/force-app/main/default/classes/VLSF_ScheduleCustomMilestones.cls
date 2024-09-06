global class VLSF_ScheduleCustomMilestones implements Schedulable{
	global void execute(SchedulableContext sc) {
		//invoke the batch class
        Database.executeBatch(new VLSF_CaseMilestones(),100);
        Database.executeBatch(new VLSF_WorkOrderMilestones(),100);
    }
}