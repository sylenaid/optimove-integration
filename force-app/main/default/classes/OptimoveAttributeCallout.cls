/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 08-19-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveAttributeCallout extends OptimoveApi {
    public List<OptimoveAttribute> getCustomerAttributes(String customerId) {
        String resource = String.format(
            SPGeneralSettings.getInstance()
                .getValue(Constants.OPTIMOVE_GET_ATTRIBUTES_ENDPOINT),
            new List<String>{ customerId }
        );

        get(resource, null, null);

        if (!isResponseCodeSuccess())
            throw getError();

        return (List<OptimoveAttribute>) JSON.deserialize(
            resp.getBody(),
            List<OptimoveAttribute>.class
        );
    }

    public void updateCustomerAttributes(
        OptimoveMultipleCustomerAttributes customerAttributes
    ) {
        String resource = SPGeneralSettings.getInstance()
            .getValue(Constants.OPTIMOVE_UPDATE_ATTRIBUTES_ENDPOINT);
        String requestBody = Json.serialize(customerAttributes, true);

        post(resource, null, null, requestBody);

        if (!isResponseCodeSuccess())
            throw getError();
    }
}
