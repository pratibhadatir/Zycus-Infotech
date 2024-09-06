/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_Competitive_Win_Loss_Anala6DTrigger on Competitive_Win_Loss_Analysis__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(Competitive_Win_Loss_Analysis__c.SObjectType);
}