public class VLSF_WorkOrderMilestones implements Database.Batchable<sObject>{
    
	public Database.QueryLocator start(Database.BatchableContext bc)
    {
        //String mileId='1EMRR000000dlNF4AY'; // this id is used in query and is for testing purpose only.
        String statusClose='Closed';
        //String query='Select Id,ParentEntityId, CompletionDate, ElapsedTimeInDays, ElapsedTimeInHrs, ElapsedTimeInMins, IsCompleted, IsViolated, StartDate, TargetDate, TargetResponseInDays, TargetResponseInHrs, TargetResponseInMins, TimeRemainingInDays, TimeRemainingInMins, TimeSinceTargetInDays, TimeSinceTargetInHrs, TimeSinceTargetInMins From EntityMilestone where Id=:mileId';
        String query='Select Id,ParentEntityId, CompletionDate, ElapsedTimeInDays, ElapsedTimeInHrs, ElapsedTimeInMins, IsCompleted, IsViolated, StartDate, TargetDate, TargetResponseInDays, TargetResponseInHrs, TargetResponseInMins, TimeRemainingInDays, TimeRemainingInMins, TimeSinceTargetInDays, TimeSinceTargetInHrs, TimeSinceTargetInMins From EntityMilestone  Where ParentEntityId IN (Select Id From WorkOrder Where Case.Status!=:statusClose)'+(Test.isRunningTest()?' LIMIT 200':'');
        return Database.getQueryLocator(query);
   	}
	public void execute(Database.BatchableContext bc, List<EntityMilestone> scope)
   	{            
        List<VLSF_Milestones__c> listCustMiles=new List<VLSF_Milestones__c>();
        for(EntityMilestone s : scope) 
        {
            if(s.ParentEntityId.toString().startsWith('0WO'))
            {
            	VLSF_Milestones__c custMile=new VLSF_Milestones__c();
            	custMile.VLSF_WorkOrderMilestoneID__c=s.Id;
                //custMile.VLSF_Case__c=wo_case_IdMap.get(s.Id); //dff
            	custMile.VLSF_Work_Order__c=s.ParentEntityId;
            	custMile.VLSF_Agreement_Type__c='OLA';
            
            	custMile.VLSF_CompletionDate__c= s.CompletionDate;
            	custMile.VLSF_Elapsed_Time_Days__c= s.ElapsedTimeInDays;
            	custMile.VLSF_Elapsed_Time_Hours__c= s.ElapsedTimeInHrs;
            	custMile.VLSF_Elapsed_Time_Mins__c= s.ElapsedTimeInMins;
            	custMile.VLSF_IsCompleted__c= s.IsCompleted;
            	custMile.VLSF_IsViolated__c=s.IsViolated;
            	custMile.VLSF_Start_Date__c=s.StartDate;
            	custMile.VLSF_Target_Date__c=s.TargetDate;
            	custMile.VLSF_Target_Response_Days__c=s.TargetResponseInDays;
            	custMile.VLSF_Target_Response_Hours__c=s.TargetResponseInHrs;
            	custMile.VLSF_Target_Response_In_Mins__c=s.TargetResponseInMins;
            	custMile.VLSF_Time_Remaining_Days__c=s.TimeRemainingInDays;
            	custMile.VLSF_Time_Remaining_Hour_Min__c=s.TimeRemainingInMins;
            	custMile.VLSF_TimeRemainingInMins__c=s.TimeRemainingInMins;
            	custMile.VLSF_Time_Since_Target_Days__c=s.TimeSinceTargetInDays;
            	custMile.VLSF_Time_Since_Target_Hour_Min__c=s.TimeSinceTargetInHrs;
            	custMile.VLSF_TimeSinceTargetInMins__c=s.TimeSinceTargetInMins;
            
            	listCustMiles.add(custMile);
            }
        }
        upsert listCustMiles VLSF_WorkOrderMilestoneID__c;
    }
   	public void finish(Database.BatchableContext bc)
   	{
    	   System.debug('Batch Finished..');
   	}

}