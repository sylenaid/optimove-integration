/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-03-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/

@isTest
private class OptimoveCommLogCtrlTest {
    @isTest
    static void testSuccessGetChannels() {
        List<OptionWrapper> channels = OptimoveCommLogCtrl.getChannels();

        Assert.isNotNull(channels, 'Channels should not be null.');
        Assert.isFalse(channels.isEmpty(), 'Channels should not be empty.');
    }

    @isTest
    static void testSuccessGetStatuses() {
        List<OptionWrapper> statuses = OptimoveCommLogCtrl.getStatuses();

        Assert.isNotNull(statuses, 'Channels should not be null.');
        Assert.isFalse(statuses.isEmpty(), 'Channels should not be empty.');
    }

    @isTest
    static void testSuccessGetCommLogs() {
        OptimoveCommLogFilter filter = OptimoveTestData.getFilter();
        OptimoveTestData.setGetCommLogCalloutMocks(filter, true);

        Test.startTest();

        List<OptimoveCommLogWrapper> logs = OptimoveCommLogCtrl.getCommLog(
            filter
        );

        Test.stopTest();

        Assert.isNotNull(logs, 'Comm logs should not be null.');
        Assert.isFalse(logs.isEmpty(), 'Comm logs should not be empty.');
    }

    @isTest
    static void testFailedGetCommLogs() {
        Boolean exceptionThrown = false;

        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());
        OptimoveCommLogFilter filter = OptimoveTestData.getFilter();

        Test.startTest();

        try {
            List<OptimoveCommLogWrapper> logs = OptimoveCommLogCtrl.getCommLog(
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
    static void testSuccessGetMarketingTemplate() {
        Test.setMock(
            HttpCalloutMock.class,
            CalloutMock.getStaticResourceSuccessMock(
                'TestOptimoveGetTemplatesOk'
            )
        );
        OptimoveCommLogWrapper log = getLog();

        Test.startTest();

        OptimoveTemplateWrapper template = OptimoveCommLogCtrl.getTemplateDetails(
            log
        );

        Test.stopTest();

        Assert.isNotNull(template, 'Comm logs should not be null.');
    }

    @isTest
    static void testSuccessGetTransactionalTemplate() {
        Test.setMock(
            HttpCalloutMock.class,
            CalloutMock.getStaticResourceSuccessMock(
                'TestOptimoveGetTemplatesOk'
            )
        );
        OptimoveCommLogWrapper log = getLog();
        log.isMarketingSend = false;

        Test.startTest();

        OptimoveTemplateWrapper template = OptimoveCommLogCtrl.getTemplateDetails(
            log
        );

        Test.stopTest();

        Assert.isNotNull(template, 'Comm logs should not be null.');
    }

    @isTest
    static void testFailedGetTemplateDetails() {
        Boolean exceptionThrown = false;

        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());
        OptimoveCommLogWrapper log = getLog();

        Test.startTest();

        try {
            OptimoveTemplateWrapper template = OptimoveCommLogCtrl.getTemplateDetails(
                log
            );

            Assert.fail('Exception should be thrown.');
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Test.stopTest();

        Assert.isTrue(exceptionThrown, 'Exception should be thrown.');
    }

    static OptimoveCommLogWrapper getLog() {
        OptimoveCommLogWrapper log = new OptimoveCommLogWrapper();
        log.id = '123';
        log.channel = 'Email';
        log.channelId = 15;
        log.subject = 'abc';
        log.dateSent = '2024-09-11';
        log.status = 'Open';
        log.statusId = 2;
        log.templateId = 5;
        log.isMarketingSend = true;

        return log;
    }
}
