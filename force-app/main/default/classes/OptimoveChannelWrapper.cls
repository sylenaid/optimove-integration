/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 08-21-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveChannelWrapper {
    @AuraEnabled
    public Integer id { get; set; }

    @AuraEnabled
    public String label { get; set; }

    @AuraEnabled
    public String name { get; set; }

    @AuraEnabled
    public String uniqueId { get; set; }

    @AuraEnabled
    public Boolean optIn { get; set; }

    public OptimoveChannelWrapper() {
    }

    public OptimoveChannelWrapper(
        Integer id,
        String label,
        String name,
        Boolean optIn,
        String topicId
    ) {
        this.id = id;
        this.label = label;
        this.name = name;
        this.optIn = optIn;
        uniqueId = topicId + '|' + id;
    }
}
