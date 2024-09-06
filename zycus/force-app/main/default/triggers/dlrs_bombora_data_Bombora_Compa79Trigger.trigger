/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_bombora_data_Bombora_Compa79Trigger on bombora_data__Bombora_Company_Surge__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(bombora_data__Bombora_Company_Surge__c.SObjectType);
}