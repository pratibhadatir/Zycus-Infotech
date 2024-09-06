public with sharing class SLAOLATriggerHandler {
    public static void handleCases(List<Case> newCases) {
        
        if (!newCases.isEmpty()) {
            Set<Id> caseIds = new Set<Id>();
            for(Case c : newCases)
            {   
                caseIds.add(c.Id);
            }
            updateMilestones(caseIds);
            updateWorkOrderMilestones(caseIds);
        }
    }
	//@future
    //public static void handleNewCases(Set<Id> caseIds) {
            //updateMilestones(caseIds);
           // updateWorkOrderMilestones(caseIds);
    //}
	@future
    @TestVisible private  static void updateMilestones(Set<Id> cases) {
        List<CaseMilestone> caseMilestones = [Select Id,CaseId,MilestoneType.Name,CompletionDate,ElapsedTimeInDays,ElapsedTimeInHrs,ElapsedTimeInMins,IsCompleted,IsViolated,StartDate,TargetDate,TargetResponseInDays,TargetResponseInHrs,TargetResponseInMins,TimeRemainingInDays,TimeRemainingInMins,TimeSinceTargetInDays,TimeSinceTargetInHrs,TimeSinceTargetInMins from CaseMilestone WHERE CaseId IN :cases];
        system.debug('caseMilestones...'+caseMilestones);
		
        List<VLSF_Milestones__C> custMileList=new List<VLSF_Milestones__c>();
        for(CaseMilestone cm: caseMilestones)
        {
            VLSF_Milestones__C custMile=new VLSF_Milestones__C();
            custMile.VLSF_CaseMilestoneID__c=cm.Id;
            custMile.VLSF_Case__c=cm.CaseId;
            custMile.VLSF_Agreement_Type__c='SLA';
            custMile.VLSF_Milestone_Name__c=cm.MilestoneType.Name;
            
            custMile.VLSF_CompletionDate__c= cm.CompletionDate;
            custMile.VLSF_Elapsed_Time_Days__c= cm.ElapsedTimeInDays;
            custMile.VLSF_Elapsed_Time_Hours__c= cm.ElapsedTimeInHrs;
            custMile.VLSF_Elapsed_Time_Mins__c= cm.ElapsedTimeInMins;
            custMile.VLSF_IsCompleted__c= cm.IsCompleted;
            custMile.VLSF_IsViolated__c=cm.IsViolated;
            custMile.VLSF_Start_Date__c=cm.StartDate;
            custMile.VLSF_Target_Date__c=cm.TargetDate;
            custMile.VLSF_Target_Response_Days__c=cm.TargetResponseInDays;
            custMile.VLSF_Target_Response_Hours__c=cm.TargetResponseInHrs;
            custMile.VLSF_Target_Response_In_Mins__c=cm.TargetResponseInMins;
            custMile.VLSF_Time_Remaining_Days__c=cm.TimeRemainingInDays;
            custMile.VLSF_Time_Remaining_Hour_Min__c=cm.TimeRemainingInMins;
            custMile.VLSF_TimeRemainingInMins__c=cm.TimeRemainingInMins;
            custMile.VLSF_Time_Since_Target_Days__c=cm.TimeSinceTargetInDays;
            custMile.VLSF_Time_Since_Target_Hour_Min__c=cm.TimeSinceTargetInHrs;
            custMile.VLSF_TimeSinceTargetInMins__c=cm.TimeSinceTargetInMins;
            //custMile.VLSF_Milestone_Name__c='Trigger'; // This is to be removed after testing
            custMileList.add(custMile);
        }
        if(!custMileList.isEmpty())
        	upsert custMileList VLSF_CaseMilestoneID__c;
        
    }
	@future
    @TestVisible private static void updateWorkOrderMilestones(Set<Id> caseIds) {
        List<VLSF_Milestones__c> listCustMiles=new List<VLSF_Milestones__c>();       
		List<WorkOrder> wo_List=[Select Id,VLSF_Assigned_To__c,VLSF_Sub_Team__c,CaseId from WorkOrder WHERE CaseId IN : caseIds];
        Map<Id,String> mapAssignedTo=new Map<Id,String>();
        Map<Id,String> mapSubTeam=new Map<Id,String>();
        Map<Id,String> mapCaseId=new Map<Id,String>();
        Set<Id> wo_Ids=new Set<Id>();
        for(WorkOrder wo:wo_List)
        {
            wo_Ids.add(wo.Id);
            mapAssignedTo.put(wo.Id,wo.VLSF_Assigned_To__c);
            mapSubTeam.put(wo.Id,wo.VLSF_Sub_Team__c);
            mapCaseId.put(wo.Id,wo.CaseId);
        }
        List<EntityMilestone> em = [Select Id,MilestoneType.Name,ParentEntityId, CompletionDate, ElapsedTimeInDays, ElapsedTimeInHrs, ElapsedTimeInMins, IsCompleted, IsViolated, StartDate, TargetDate, TargetResponseInDays, TargetResponseInHrs, TargetResponseInMins, TimeRemainingInDays, TimeRemainingInMins, TimeSinceTargetInDays, TimeSinceTargetInHrs, TimeSinceTargetInMins From EntityMilestone  Where ParentEntityId IN :wo_Ids];
        for(EntityMilestone s : em) 
        {
            if(s.ParentEntityId.toString().startsWith('0WO'))
            {
            	VLSF_Milestones__c custMile=new VLSF_Milestones__c();
            	custMile.VLSF_WorkOrderMilestoneID__c=s.Id;
                custMile.VLSF_Case__c=mapCaseId.get(s.ParentEntityId); //dff
            	custMile.VLSF_Work_Order__c=s.ParentEntityId;
            	custMile.VLSF_Agreement_Type__c='OLA';
                custMile.VLSF_Assigned_To__c=mapAssignedTo.get(s.ParentEntityId);
                custMile.VLSF_Sub_Team__c=mapSubTeam.get(s.ParentEntityId);
                custMile.VLSF_Milestone_Name__c=s.MilestoneType.Name;
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
                //custMile.VLSF_Milestone_Name__c='Trigger'; // This is to be removed after testing
            	listCustMiles.add(custMile);
            }
            
            if(!listCustMiles.isEmpty())
        	upsert listCustMiles VLSF_WorkOrderMilestoneID__c;
        }
	}
}