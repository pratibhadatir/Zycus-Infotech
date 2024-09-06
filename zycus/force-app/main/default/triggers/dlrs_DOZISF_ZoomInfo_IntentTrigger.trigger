/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_DOZISF_ZoomInfo_IntentTrigger on DOZISF__ZoomInfo_Intent__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(DOZISF__ZoomInfo_Intent__c.SObjectType);
}