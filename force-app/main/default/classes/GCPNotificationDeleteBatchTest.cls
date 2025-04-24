/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-03-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
@isTest
private class GCPNotificationDeleteBatchTest {
    @isTest
    static void notifyEvent11SuccessTest() {
        OptimoveTestData.getNotifications(150, true);

        Test.startTest();

        new GCPNotificationDeleteBatch().executeBatch();

        Test.stopTest();

        List<GCP_Notification__c> notifications = [
            SELECT Status__c, Attempts__c
            FROM GCP_Notification__c
        ];

        Assert.isTrue(
            notifications.isEmpty(),
            'Notifications should be empty.'
        );
    }
}
