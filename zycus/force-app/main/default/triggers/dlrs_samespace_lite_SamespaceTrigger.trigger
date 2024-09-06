/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_samespace_lite_SamespaceTrigger on samespace_lite__Samespace__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(samespace_lite__Samespace__c.SObjectType);
}