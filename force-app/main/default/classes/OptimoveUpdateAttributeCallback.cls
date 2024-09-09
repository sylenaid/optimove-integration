/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 08-27-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
@RestResource(urlMapping='/optimove/attr/callback')
global with sharing class OptimoveUpdateAttributeCallback {
    @HttpPost
    global static void doPost() {
        try {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            String requestBody = req.requestBody.toString();

            OptimoveUpdateAttributeResponse r = getResponse(requestBody);

            if (!r.isSuccess)
                Logger.error(
                    'Error updating Optimove attributes',
                    Constants.LOGGER_OPTIMOVE_API_CATEGORY,
                    JSON.serialize(r.errors)
                );
        } catch (Exception ex) {
            Logger.exception(Constants.LOGGER_OPTIMOVE_API_CATEGORY, ex);
        } finally {
            RestContext.response.statusCode = 200;
        }
    }

    static OptimoveUpdateAttributeResponse getResponse(String requestBody) {
        return (OptimoveUpdateAttributeResponse) JSON.deserialize(
            requestBody,
            OptimoveUpdateAttributeResponse.class
        );
    }
}
