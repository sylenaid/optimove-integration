/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-27-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveCommLogWrapper {
    @AuraEnabled
    public String id { get; set; }

    @AuraEnabled
    public String channel { get; set; }

    @AuraEnabled
    public Integer channelId { get; set; }

    @AuraEnabled
    public String subject { get; set; }

    @AuraEnabled
    public String dateSent { get; set; }

    @AuraEnabled
    public String status { get; set; }

    @AuraEnabled
    public Integer statusId { get; set; }

    @AuraEnabled
    public Integer templateId { get; set; }

    @AuraEnabled
    public Boolean isMarketingSend { get; set; }

    public OptimoveCommLogWrapper() {
    }

    public OptimoveCommLogWrapper(GCPCommLog gcpCommLog) {
        channelId = gcpCommLog.channelIdentifier;
        subject = gcpCommLog.TemplateName ?? '';
        templateId = gcpCommLog.templateIdentifier;
        dateSent = gcpCommLog.ScheduleTime ?? '';
        isMarketingSend = gcpCommLog.isMarketingEmail;
        id = channelId + '|' + templateId + '|' + dateSent;
        status = '';
    }
}
