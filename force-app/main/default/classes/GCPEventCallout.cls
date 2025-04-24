/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-18-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class GCPEventCallout extends GCPApi {
    public void notifyEvent11(String requestBody) {
        String resource = SPGeneralSettings.getInstance()
            .getValue(Constants.GCP_NOTIFY_EVENT11_ENDPOINT);

        post(resource, headers, null, requestBody);

        if (!isResponseCodeSuccess())
            throw getError();
    }

    public void notifyEvent13(String requestBody) {
        String resource = SPGeneralSettings.getInstance()
            .getValue(Constants.GCP_NOTIFY_EVENT13_ENDPOINT);

        post(resource, headers, null, requestBody);

        if (!isResponseCodeSuccess())
            throw getError();
    }
}
