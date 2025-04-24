/**
 * @description       : 
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             : 
 * @last modified on  : 10-03-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
**/
@isTest
private class OptimoveTransactionalCommLogCalloutTest {
    @isTest
    static void testSuccessGetTemplates() {
        Test.setMock(
            HttpCalloutMock.class,
            CalloutMock.getStaticResourceSuccessMock(
                'TestOptimoveGetTemplatesOk'
            )
        );

        Test.startTest();

        OptimoveTransactionalCommLogCallout c = new OptimoveTransactionalCommLogCallout();
        List<OptimoveTemplate> templates = c.getTemplates();

        Test.stopTest();

        Assert.isNotNull(templates, 'Templates should not be null.');
        Assert.isFalse(templates.isEmpty(), 'Templates should not be empty.');
    }

    @isTest
    static void testFailedGetTemplates() {
        Boolean exceptionThrown = false;

        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());

        Test.startTest();

        try {
            OptimoveTransactionalCommLogCallout c = new OptimoveTransactionalCommLogCallout();
            List<OptimoveTemplate> templates = c.getTemplates();
            Assert.fail('Exception should be thrown.');
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Test.stopTest();

        Assert.isTrue(exceptionThrown, 'Exception should be thrown.');
    }
}
