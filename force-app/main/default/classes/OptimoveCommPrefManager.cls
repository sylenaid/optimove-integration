/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 08-22-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveCommPrefManager {
    final String GENERAL_TOPIC_ID = '0';
    final String GENERAL_TOPIC_LABEL = 'General';
    final String GENERAL_TOPIC_DESC = 'General';
    OptimoveAttributeCallout attrCallout;
    OptimovePreferenceCallout prefCallout;
    OptimoveSettingsManager settings;

    public OptimoveCommPrefManager() {
        settings = new OptimoveSettingsManager();
        attrCallout = new OptimoveAttributeCallout();
        prefCallout = new OptimovePreferenceCallout();
    }

    public OptimovePreferenceWrapper getPreferences(String customerId) {
        String brandGroupId = settings.getBrandGroupId();
        List<OptimoveAttribute> attributes = attrCallout.getCustomerAttributes(
            customerId
        );
        OptimoveCustomerPreferences preferences = prefCallout.getCustomerPreferences(
            customerId,
            brandGroupId
        );
        List<Optimove_Settings__mdt> enabledChannels = getEnabledChannels(
            preferences.channels
        );
        OptimovePreferenceWrapper result = new OptimovePreferenceWrapper();

        result.general = getGeneralTopic(
            attributes,
            preferences,
            enabledChannels
        );
        result.topics.addAll(getTopics(preferences, enabledChannels));

        return result;
    }

    public void updatePreferences(
        String customerId,
        List<OptimoveTopicWrapper> preferences
    ) {
        OptimoveTopicWrapper gral = null;
        List<OptimoveTopic> topics = new List<OptimoveTopic>();

        for (OptimoveTopicWrapper topicWrapper : preferences) {
            if (topicWrapper.id == GENERAL_TOPIC_ID)
                gral = topicWrapper;
            else
                topics.add(topicWrapper.toTopic());
        }

        updateAttributes(customerId, gral);
        updateTopics(customerId, topics);
    }

    List<Optimove_Settings__mdt> getEnabledChannels(
        List<Integer> preferenceChannels
    ) {
        List<Optimove_Settings__mdt> result = new List<Optimove_Settings__mdt>();
        List<Optimove_Settings__mdt> channelsEnableBySetting = settings.getChannelSettigs();

        for (Optimove_Settings__mdt channel : channelsEnableBySetting) {
            Integer channelId = Integer.valueOf(channel.External_Id__c);

            if (
                !settings.checkPreferenceChannels() ||
                preferenceChannels.contains(channelId)
            )
                result.add(channel);
        }

        return result;
    }

    OptimoveTopicWrapper getGeneralTopic(
        List<OptimoveAttribute> attributes,
        OptimoveCustomerPreferences preferences,
        List<Optimove_Settings__mdt> enabledChannels
    ) {
        List<OptimoveChannelWrapper> generalChannels = new List<OptimoveChannelWrapper>();
        Map<String, OptimoveAttribute> attributesByName = new Map<String, OptimoveAttribute>();

        for (OptimoveAttribute attribute : attributes)
            attributesByName.put(attribute.RealFieldName, attribute);

        for (Optimove_Settings__mdt channel : enabledChannels) {
            if (attributesByName.containsKey(channel.DeveloperName)) {
                String value = attributesByName.get(channel.DeveloperName)
                    .Value;
                Boolean optIn = (value ?? '').toLowerCase() == 'true';

                generalChannels.add(
                    new OptimoveChannelWrapper(
                        Integer.valueOf(channel.External_Id__c),
                        channel.MasterLabel,
                        channel.DeveloperName,
                        optIn,
                        GENERAL_TOPIC_ID
                    )
                );
            }
        }

        return new OptimoveTopicWrapper(
            GENERAL_TOPIC_ID,
            GENERAL_TOPIC_LABEL,
            GENERAL_TOPIC_DESC,
            generalChannels
        );
    }

    List<OptimoveTopicWrapper> getTopics(
        OptimoveCustomerPreferences preferences,
        List<Optimove_Settings__mdt> enabledChannels
    ) {
        List<OptimoveTopicWrapper> result = new List<OptimoveTopicWrapper>();

        for (OptimoveTopic topic : preferences.topics) {
            List<OptimoveChannelWrapper> channelWrappers = new List<OptimoveChannelWrapper>();

            for (Optimove_Settings__mdt channel : enabledChannels) {
                Integer channelId = Integer.valueOf(channel.External_Id__c);

                channelWrappers.add(
                    new OptimoveChannelWrapper(
                        channelId,
                        channel.MasterLabel,
                        channel.DeveloperName,
                        topic.channelSubscription.contains(channelId),
                        topic.topicId
                    )
                );
            }

            result.add(
                new OptimoveTopicWrapper(
                    topic.topicId,
                    topic.topicName,
                    topic.topicDescription,
                    channelWrappers
                )
            );
        }

        return result;
    }

    private void updateAttributes(
        String customerId,
        OptimoveTopicWrapper generalTopic
    ) {
        if (generalTopic == null)
            return;

        OptimoveCustomerAttribute customerAttributes = new OptimoveCustomerAttribute();
        customerAttributes.CustomerId = customerId;

        for (OptimoveChannelWrapper chW : generalTopic.channels)
            customerAttributes.Attributes.add(new OptimoveAttribute(chW));

        OptimoveMultipleCustomerAttributes mCustomerAttributes = new OptimoveMultipleCustomerAttributes();
        mCustomerAttributes.CallbackURL = settings.getCallbackUrl();

        mCustomerAttributes.CustomerNewAttributesValuesList.add(
            customerAttributes
        );

        attrCallout.updateCustomerAttributes(mCustomerAttributes);
    }

    private void updateTopics(String customerId, List<OptimoveTopic> topics) {
        String brandGroupId = settings.getBrandGroupId();

        if (!topics.isEmpty())
            prefCallout.updateCustomerPreferences(
                customerId,
                brandGroupId,
                topics
            );
    }
}
