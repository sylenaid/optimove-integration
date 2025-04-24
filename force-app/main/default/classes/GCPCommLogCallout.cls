/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-04-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class GCPCommLogCallout extends GCPApi {
    public List<GCPCommLog> getCommLogs(OptimoveCommLogFilter filter) {
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
                .getValue(Constants.GCP_GET_COMMUNICATION_LOGS_ENDPOINT),
            new List<String>{
                filter.customerId,
                formattedStartDate,
                formattedEndDate
            }
        );

        get(resource, headers, null);

        if (!isResponseCodeSuccess())
            throw getError();

        return (List<GCPCommLog>) JSON.deserialize(
            resp.getBody(),
            List<GCPCommLog>.class
        );
    }
}
