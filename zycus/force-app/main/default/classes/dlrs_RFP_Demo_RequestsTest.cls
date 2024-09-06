/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_RFP_Demo_RequestsTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_RFP_Demo_RequestsTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new RFP_Demo_Requests__c());
    }
}