/**
 * @description       : 
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             : 
 * @last modified on  : 08-20-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
**/
public with sharing class OptimovePreferenceWrapper {
    @AuraEnabled
    public OptimoveTopicWrapper general {get; set;}

    @AuraEnabled
    public List<OptimoveTopicWrapper> topics {get; set;}

    public OptimovePreferenceWrapper() {
        topics = new List<OptimoveTopicWrapper>();
    }
}