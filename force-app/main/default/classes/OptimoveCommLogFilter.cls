/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-25-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveCommLogFilter {
    @AuraEnabled
    public String customerId { get; set; }

    @AuraEnabled
    public Date startDate { get; set; }

    @AuraEnabled
    public Date endDate { get; set; }

    @AuraEnabled
    public Integer channelId { get; set; }

    public OptimoveCommLogFilter() {
    }
}
