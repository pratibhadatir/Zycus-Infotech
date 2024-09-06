/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_RFP_Demo_RequestsTrigger on RFP_Demo_Requests__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(RFP_Demo_Requests__c.SObjectType);
}