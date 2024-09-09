/**
 * @description       : 
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             : 
 * @last modified on  : 08-15-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
**/
public with sharing class OptimoveTopic {
    public String  topicId { get; set; }

    public String  topicName { get; set; }

    public String  topicDescription { get; set; }

    public List<Integer> channelSubscription { get; set; }

    public OptimoveTopic() {

    }
}