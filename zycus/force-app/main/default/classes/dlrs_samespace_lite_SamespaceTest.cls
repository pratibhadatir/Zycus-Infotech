/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_samespace_lite_SamespaceTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_samespace_lite_SamespaceTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new samespace_lite__Samespace__c());
    }
}