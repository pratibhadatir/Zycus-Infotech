/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_Marketing_EngagementTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_Marketing_EngagementTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new Marketing_Engagement__c());
    }
}