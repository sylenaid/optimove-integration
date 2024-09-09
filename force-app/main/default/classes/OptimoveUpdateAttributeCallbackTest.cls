/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 08-27-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
@isTest
class OptimoveUpdateAttributeCallbackTest {
    @isTest
    public static void testHandleSuccessCallback() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        OptimoveUpdateAttributeResponse r = new OptimoveUpdateAttributeResponse();
        r.isSuccess = true;
        r.requestId = '0386932e-db94-4567-9d38-76d98ce50e4a';
        req.requestBody = Blob.valueOf(JSON.serialize(r, true));
        RestResponse res = new RestResponse();

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

        OptimoveUpdateAttributeCallback.doPost();

        Test.stopTest();

        Assert.areEqual(200, res.statusCode, 'Status code should be 200.');
    }

    @isTest
    public static void testHandleFailedCallback() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        OptimoveUpdateAttributeResponse.OptimoveUpdateAttributeError e =
            new OptimoveUpdateAttributeResponse.OptimoveUpdateAttributeError();
        e.error = 'UPDATE_FIELD_TEMPORARY_UNAVAILABLE';
        e.customerId = '1289049';
        e.realFieldName = 'DaysSinceFirstAbsGameDate';
        OptimoveUpdateAttributeResponse r = new OptimoveUpdateAttributeResponse();
        r.isSuccess = false;
        r.requestId = '77e34963-8142-4fde-a403-ebe03feec41e';
        r.errors.add(e);
        req.requestBody = Blob.valueOf(JSON.serialize(r, true));
        RestResponse res = new RestResponse();

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

        OptimoveUpdateAttributeCallback.doPost();

        Test.stopTest();

        Assert.areEqual(200, res.statusCode, 'Status code should be 200.');
    }
    
    @isTest
    public static void testHandleExceptionCallback() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        RestResponse res = new RestResponse();

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

        OptimoveUpdateAttributeCallback.doPost();

        Test.stopTest();

        Assert.areEqual(200, res.statusCode, 'Status code should be 200.');
    }
}
