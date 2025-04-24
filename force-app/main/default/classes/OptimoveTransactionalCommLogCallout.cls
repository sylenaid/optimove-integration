/**
 * @description       : Transactional communication log callouts
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-26-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveTransactionalCommLogCallout extends OptimoveTransactionalApi {
    public List<OptimoveTemplate> getTemplates() {
        String resource = SPGeneralSettings.getInstance()
            .getValue(Constants.OPTIMOVE_GET_TRANSACTIONAL_TEMPLATE_ENDPOINT);

        get(resource, null, null);

        if (!isResponseCodeSuccess())
            throw getError();

        return (List<OptimoveTemplate>) JSON.deserialize(
            resp.getBody(),
            List<OptimoveTemplate>.class
        );
    }
}
