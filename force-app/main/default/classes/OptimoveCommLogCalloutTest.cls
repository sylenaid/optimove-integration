/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-03-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
@isTest
class OptimoveCommLogCalloutTest {
    @isTest
    static void testSuccessGetChannelInteractions() {
        Test.setMock(
            HttpCalloutMock.class,
            CalloutMock.getStaticResourceSuccessMock(
                'TestOptimoveGetChannelInteractionsOk'
            )
        );

        OptimoveCommLogFilter filter = OptimoveTestData.getFilter();

        Test.startTest();

        OptimoveCommLogCallout c = new OptimoveCommLogCallout();
        List<OptimoveChannelInteraction> interactions = c.getChannelInteractions(
            filter
        );

        Test.stopTest();

        Assert.isNotNull(
            interactions,
            'Channel interactions should not be null.'
        );
        Assert.isFalse(
            interactions.isEmpty(),
            'Channel interactions should not be empty.'
        );
    }

    @isTest
    static void testFailedGetChannelInteractions() {
        Boolean exceptionThrown = false;

        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());

        OptimoveCommLogFilter filter = OptimoveTestData.getFilter();

        Test.startTest();

        try {
            OptimoveCommLogCallout c = new OptimoveCommLogCallout();
            List<OptimoveChannelInteraction> interactions = c.getChannelInteractions(
                filter
            );
            Assert.fail('Exception should be thrown.');
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Test.stopTest();

        Assert.isTrue(exceptionThrown, 'Exception should be thrown.');
    }

    @isTest
    static void testSuccessGetTemplates() {
        Test.setMock(
            HttpCalloutMock.class,
            CalloutMock.getStaticResourceSuccessMock(
                'TestOptimoveGetTemplatesOk'
            )
        );

        Test.startTest();

        OptimoveCommLogCallout c = new OptimoveCommLogCallout();
        List<OptimoveTemplate> templates = c.getTemplates(65, 5, 'abc');

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
            OptimoveCommLogCallout c = new OptimoveCommLogCallout();
            List<OptimoveTemplate> templates = c.getTemplates(65, 7, 'abc');
            Assert.fail('Exception should be thrown.');
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Test.stopTest();

        Assert.isTrue(exceptionThrown, 'Exception should be thrown.');
    }
}
