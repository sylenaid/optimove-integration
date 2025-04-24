/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-03-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
@isTest
private class GCPEventCalloutTest {
    @isTest
    static void testSuccessNotifyEvent11() {
        OptimoveTestData.setGCPEventCalloutMocks(
            Constants.GCP_NOTIFY_EVENT11_ENDPOINT
        );

        Test.startTest();

        GCPEventCallout c = new GCPEventCallout();
        c.notifyEvent11('abc');

        Test.stopTest();

        Assert.isTrue(true, 'no error');
    }

    @isTest
    static void testFailedNotifyEvent11() {
        Boolean exceptionThrown = false;

        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());

        Test.startTest();

        try {
            GCPEventCallout c = new GCPEventCallout();
            c.notifyEvent11('abc');
            Assert.fail('Exception should be thrown.');
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Test.stopTest();

        Assert.isTrue(exceptionThrown, 'Exception should be thrown.');
    }

    @isTest
    static void testSuccessNotifyEvent13() {
        OptimoveTestData.setGCPEventCalloutMocks(
            Constants.GCP_NOTIFY_EVENT13_ENDPOINT
        );

        Test.startTest();

        GCPEventCallout c = new GCPEventCallout();
        c.notifyEvent13('abc');

        Test.stopTest();

        Assert.isTrue(true, 'no error');
    }

    @isTest
    static void testFailedNotifyEvent13() {
        Boolean exceptionThrown = false;

        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());

        Test.startTest();

        try {
            GCPEventCallout c = new GCPEventCallout();
            c.notifyEvent13('abc');
            Assert.fail('Exception should be thrown.');
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Test.stopTest();

        Assert.isTrue(exceptionThrown, 'Exception should be thrown.');
    }
}
