/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_Quote_Information_TemplateTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_Quote_Information_TemplateTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new Quote_Information_Template__c());
    }
}