/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 08-21-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveTopicWrapper {
    @AuraEnabled
    public String id { get; set; }

    @AuraEnabled
    public String name { get; set; }

    @AuraEnabled
    public String description { get; set; }

    @AuraEnabled
    public List<OptimoveChannelWrapper> channels { get; set; }

    public OptimoveTopicWrapper() {
    }

    public OptimoveTopicWrapper(
        String id,
        String name,
        String description,
        List<OptimoveChannelWrapper> channels
    ) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.channels = channels;
    }

    public OptimoveTopic toTopic() {
        OptimoveTopic result = new OptimoveTopic();
        result.topicId = this.id;
        result.channelSubscription = new List<Integer>();

        for (OptimoveChannelWrapper ch : channels)
            if (ch.optIn)
                result.channelSubscription.add(ch.id);

        return result;
    }
}
