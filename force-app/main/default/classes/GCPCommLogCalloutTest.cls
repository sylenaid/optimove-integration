/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-03-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
@isTest
class GCPCommLogCalloutTest {
    @isTest
    static void testSuccessGetCommLogs() {
        OptimoveCommLogFilter filter = OptimoveTestData.getFilter();
        OptimoveTestData.setGetCommLogCalloutMocks(filter, false);

        Test.startTest();

        GCPCommLogCallout c = new GCPCommLogCallout();
        List<GCPCommLog> logs = c.getCommLogs(filter);

        Test.stopTest();

        Assert.isNotNull(logs, 'Comm logs should not be null.');
        Assert.isFalse(logs.isEmpty(), 'Comm logs should not be empty.');
    }

    @isTest
    static void testFailedGetCommLogs() {
        Boolean exceptionThrown = false;
        OptimoveCommLogFilter filter = OptimoveTestData.getFilter();

        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());

        Test.startTest();

        try {
            GCPCommLogCallout c = new GCPCommLogCallout();
            List<GCPCommLog> logs = c.getCommLogs(filter);
            Assert.fail('Exception should be thrown.');
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Test.stopTest();

        Assert.isTrue(exceptionThrown, 'Exception should be thrown.');
    }
}
