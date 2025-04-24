/**
 * @description       : Marketing communication log callouts
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-04-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveCommLogCallout extends OptimoveApi {
    public List<OptimoveChannelInteraction> getChannelInteractions(
        OptimoveCommLogFilter filter
    ) {
        String resource = getChannelInteractionsResource(filter);

        get(resource, null, null);

        if (!isResponseCodeSuccess())
            throw getError();

        return (List<OptimoveChannelInteraction>) parseJsonToObject(
            List<OptimoveChannelInteraction>.class,
            OptimoveChannelInteraction.getPropertyMappings()
        );
    }

    public List<OptimoveTemplate> getTemplates(
        Integer channelId,
        Integer templateId,
        String templateName
    ) {
        String resource = String.format(
            SPGeneralSettings.getInstance()
                .getValue(Constants.OPTIMOVE_GET_MARKETING_TEMPLATE_ENDPOINT),
            new List<String>{
                String.valueOf(channelId),
                String.valueOf(templateId)
            }
        );

        get(resource, null, null);

        if (!isResponseCodeSuccess())
            throw getError();

        List<OptimoveTemplate> result = (List<OptimoveTemplate>) JSON.deserialize(
            resp.getBody(),
            List<OptimoveTemplate>.class
        );

        for (OptimoveTemplate t : result) {
            t.TemplateID = templateId;
            t.TemplateName = templateName;
        }

        return result;
    }

    String getChannelInteractionsResource(OptimoveCommLogFilter filter) {
        String formattedStartDate = CSUtils.formatDate(
            filter.startDate,
            'yyyy-MM-dd'
        );
        String formattedEndDate = CSUtils.formatDate(
            filter.endDate,
            'yyyy-MM-dd'
        );

        String resource = String.format(
            SPGeneralSettings.getInstance()
                .getValue(Constants.OPTIMOVE_GET_CHANNEL_INTERACTIONS_ENDPOINT),
            new List<String>{
                filter.customerId,
                formattedStartDate,
                formattedEndDate,
                filter.channelId == null
                    ? '0'
                    : String.valueOf(filter.channelId)
            }
        );

        return resource;
    }
}
