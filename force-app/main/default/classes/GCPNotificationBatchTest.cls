/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-03-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
@isTest
private class GCPNotificationBatchTest {
    @isTest
    static void notifyEvent11SuccessTest() {
        OptimoveTestData.setGCPEventCalloutMocks(
            Constants.GCP_NOTIFY_EVENT11_ENDPOINT
        );
        OptimoveTestData.getGCPNotifications(11, true);

        Test.startTest();

        new GCPNotificationBatch().executeBatch();

        Test.stopTest();

        List<GCP_Notification__c> notifications = [
            SELECT Status__c, Attempts__c
            FROM GCP_Notification__c
        ];

        Assert.areEqual(
            1,
            notifications.size(),
            'There should be 1 notification'
        );

        Assert.areEqual(
            'Processed',
            notifications[0].Status__c,
            'Status should be Processed'
        );
    }

    @isTest
    static void notifyEvent13SuccessTest() {
        OptimoveTestData.setGCPEventCalloutMocks(
            Constants.GCP_NOTIFY_EVENT13_ENDPOINT
        );

        OptimoveTestData.getGCPNotifications(13, true);

        Test.startTest();

        new GCPNotificationBatch().executeBatch();

        Test.stopTest();

        List<GCP_Notification__c> notifications = [
            SELECT Status__c, Attempts__c
            FROM GCP_Notification__c
        ];

        Assert.areEqual(
            1,
            notifications.size(),
            'There should be 1 notification'
        );

        Assert.areEqual(
            'Processed',
            notifications[0].Status__c,
            'Status should be Processed'
        );
    }

    @isTest
    static void executeFailedWithPendingItemsTest() {
        OptimoveTestData.getGCPNotifications(11, true);

        Test.startTest();

        new GCPNotificationBatch().executeBatch();

        Test.stopTest();

        List<GCP_Notification__c> notifications = [
            SELECT Status__c, Attempts__c
            FROM GCP_Notification__c
        ];

        Assert.areEqual(
            1,
            notifications.size(),
            'There should be 1 notification'
        );

        Assert.areEqual(
            1,
            notifications[0].Attempts__c,
            'Attempts should be 1'
        );

        Assert.areEqual(
            'Pending',
            notifications[0].Status__c,
            'Status should be Processed'
        );
    }

    @isTest
    static void executeFailedCalloutWithPendingItemsTest() {
        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());

        OptimoveTestData.getGCPNotifications(13, true);

        Test.startTest();

        new GCPNotificationBatch().executeBatch();

        Test.stopTest();

        List<GCP_Notification__c> notifications = [
            SELECT Status__c, Attempts__c
            FROM GCP_Notification__c
        ];

        Assert.areEqual(
            1,
            notifications.size(),
            'There should be 1 notification'
        );

        Assert.areEqual(
            1,
            notifications[0].Attempts__c,
            'Attempts should be 1'
        );

        Assert.areEqual(
            'Pending',
            notifications[0].Status__c,
            'Status should be Processed'
        );
    }
}
