public class VLSF_CaseMilestones implements Database.Batchable<sObject>{
    
	public Database.QueryLocator start(Database.BatchableContext bc)
    {
        //String mileId='555RR00000CQe6DYAT'; // this id is used in query and is for testing purpose only.
        String statusClose='Closed';
        //String query='Select Id,CaseId,CompletionDate,ElapsedTimeInDays,ElapsedTimeInHrs,ElapsedTimeInMins,IsCompleted,IsViolated,StartDate,TargetDate,TargetResponseInDays,TargetResponseInHrs,TargetResponseInMins,TimeRemainingInDays,TimeRemainingInMins,TimeSinceTargetInDays,TimeSinceTargetInHrs,TimeSinceTargetInMins From CaseMilestone where Id=:mileId';
        String query='Select Id,CaseId,CompletionDate,ElapsedTimeInDays,ElapsedTimeInHrs,ElapsedTimeInMins,IsCompleted,IsViolated,StartDate,TargetDate,TargetResponseInDays,TargetResponseInHrs,TargetResponseInMins,TimeRemainingInDays,TimeRemainingInMins,TimeSinceTargetInDays,TimeSinceTargetInHrs,TimeSinceTargetInMins From CaseMilestone Where CaseId In (Select Id from Case where Status != :statusClose)'+(Test.isRunningTest()?' LIMIT 200':'');
        return Database.getQueryLocator(query);
   	}
	public void execute(Database.BatchableContext bc, List<CaseMilestone> scope)
   	{
        List<VLSF_Milestones__c> listCustMiles=new List<VLSF_Milestones__c>();
        for(CaseMilestone s : scope) 
        {
            VLSF_Milestones__c custMile=new VLSF_Milestones__c();
            custMile.VLSF_CaseMilestoneID__c=s.Id;
            custMile.VLSF_Case__c=s.CaseId;
            custMile.VLSF_Agreement_Type__c='SLA';
            
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
        upsert listCustMiles VLSF_CaseMilestoneID__c;
    }
   	public void finish(Database.BatchableContext bc)
   	{
    	   System.debug('Batch Finished..');
         
   	}
   
}