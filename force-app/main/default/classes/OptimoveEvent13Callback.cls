/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-09-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
@RestResource(urlMapping='/optimove/event13/callback')
global with sharing class OptimoveEvent13Callback {
    @HttpPost
    global static void doPost() {
        try {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            String requestBody = req.requestBody.toString();

            OptimoveEventManager eventManager = new OptimoveEventManager();

            eventManager.processEvent(13, requestBody);
        } catch (Exception ex) {
            Logger.exception(Constants.LOGGER_OPTIMOVE_API_CATEGORY, ex);
        } finally {
            RestContext.response.statusCode = 200;
        }
    }
}
