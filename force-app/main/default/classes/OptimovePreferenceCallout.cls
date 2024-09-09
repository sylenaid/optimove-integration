/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 08-27-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimovePreferenceCallout
        extends OptimovePublicApi {
    public OptimoveCustomerPreferences getCustomerPreferences(
        String customerId,
        String brandGroupId
    ) {
        String resource = String.format(
            SPGeneralSettings.getInstance()
                .getValue(Constants.OPTIMOVE_PREFERENCES_ENDPOINT),
            new List<String>{ brandGroupId, customerId}
        );

        get(resource, null, null);

        if (!isResponseCodeSuccess())
            throw getError();

        return (OptimoveCustomerPreferences) JSON.deserialize(
            resp.getBody(),
            OptimoveCustomerPreferences.class
        );
    }

    public void updateCustomerPreferences(
        String customerId,
        String brandGroupId,
        List<OptimoveTopic> topics
    ) {
        String resource = String.format(
            SPGeneralSettings.getInstance()
                .getValue(Constants.OPTIMOVE_PREFERENCES_ENDPOINT),
            new List<String>{ brandGroupId, customerId }
        );
        String requestBody = Json.serialize(topics, true);

        put(resource, null, null, requestBody);

        if (!isResponseCodeSuccess())
            throw getError();
    }
}
