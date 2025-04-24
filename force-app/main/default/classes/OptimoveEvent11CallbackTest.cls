/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-03-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
@isTest
class OptimoveEvent11CallbackTest {
    @isTest
    public static void receivingEvent11FromOptimoveTest() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('abc');
        RestResponse res = new RestResponse();

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

        OptimoveEvent11Callback.doPost();

        Test.stopTest();

        List<GCP_Notification__c> notifications = [
            SELECT Optimove_Event_Payload__c, Status__c
            FROM GCP_Notification__c
        ];

        Assert.areEqual(200, res.statusCode, 'Status code should be 200.');
        Assert.areEqual(1, notifications.size(), 'Should be 1 notification');
        Assert.areEqual(
            'Pending',
            notifications[0].Status__c,
            'Invalid status'
        );
        Assert.areEqual(
            'abc',
            notifications[0].Optimove_Event_Payload__c,
            'Invalid payload'
        );
    }
}
