/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-03-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
@isTest
public class OptimoveTestData {
    public static List<OptimoveTopicWrapper> getPreferences(
        Boolean changeGeneralTopic
    ) {
        List<OptimoveTopicWrapper> preferences = new List<OptimoveTopicWrapper>();

        preferences.add(
            new OptimoveTopicWrapper(
                'test',
                'test',
                'test',
                new List<OptimoveChannelWrapper>{
                    new OptimoveChannelWrapper(1, 'test', 'test', false, 'test')
                }
            )
        );

        if (changeGeneralTopic) {
            OptimoveChannelWrapper w = new OptimoveChannelWrapper();
            w.id = 1;
            w.label = 'test';
            w.name = 'test';
            w.optIn = true;

            List<OptimoveChannelWrapper> channels = new List<OptimoveChannelWrapper>();
            channels.add(w);

            preferences.add(
                new OptimoveTopicWrapper('0', 'test', 'test', channels)
            );
        }

        return preferences;
    }

    public static OptimoveCommLogFilter getFilter() {
        OptimoveCommLogFilter filter = new OptimoveCommLogFilter();
        filter.customerId = 'abc123';
        filter.startDate = Date.today();
        filter.endDate = Date.today() - 90;
        filter.channelId = 65;

        return filter;
    }

    public static GCP_Notification__c getGCPNotifications(
        Integer eventType,
        Boolean performDML
    ) {
        GCP_Notification__c n = new GCP_Notification__c(
            Optimove_Event_Type_Id__c = eventType,
            Optimove_Event_Payload__c = 'abc'
        );

        if (performDML)
            insert n;

        return n;
    }

    public static void setGetPreferencesCalloutMocks() {
        SPGeneralSettings genSettings = SPGeneralSettings.getInstance();
        String attrResource = getAttributesResourceUrl(genSettings);
        String prefResource = getPreferencesResourceUrl(genSettings);

        Test.setMock(
            HttpCalloutMock.class,
            CalloutMock.getMultiStaticResourceSuccessMock(
                new List<CalloutMock.MultiStaticResourceItem>{
                    new CalloutMock.MultiStaticResourceItem(
                        attrResource,
                        'TestOptimoveGetAttributesOk'
                    ),
                    new CalloutMock.MultiStaticResourceItem(
                        prefResource,
                        'TestOptimoveGetPreferencesOk'
                    )
                }
            )
        );
    }

    public static void setGetCommLogCalloutMocks(
        OptimoveCommLogFilter filter,
        Boolean includeInteractions
    ) {
        SPGeneralSettings genSettings = SPGeneralSettings.getInstance();
        OptimoveSettingsManager settings = new OptimoveSettingsManager();
        String tokenResource = getGCPTokenResourceUrl();
        String commLogResource = getCommLogResourceUrl(genSettings, filter);
        List<CalloutMock.MultiStaticResourceItem> mocks = new List<CalloutMock.MultiStaticResourceItem>{
            new CalloutMock.MultiStaticResourceItem(
                tokenResource,
                'TestGCPGetTokenOk'
            ),
            new CalloutMock.MultiStaticResourceItem(
                commLogResource,
                'TestGCPGetCommLogOk'
            )
        };

        if (includeInteractions) {
            for (Integer channelId : settings.getEnabledChannels().keySet()) {
                filter.channelId = channelId;
                mocks.add(
                    new CalloutMock.MultiStaticResourceItem(
                        getChannelInteractionsResourceUrl(genSettings, filter),
                        'TestOptimoveGetChannelInteractionsOk'
                    )
                );
            }
        }

        Test.setMock(
            HttpCalloutMock.class,
            CalloutMock.getMultiStaticResourceSuccessMock(mocks)
        );
    }

    public static void setGCPEventCalloutMocks(String eventResourceName) {
        SPGeneralSettings genSettings = SPGeneralSettings.getInstance();
        String tokenResource = getGCPTokenResourceUrl();
        String eventResource = getEventResourceUrl(
            genSettings,
            eventResourceName
        );

        Test.setMock(
            HttpCalloutMock.class,
            CalloutMock.getMultiStaticResourceSuccessMock(
                new List<CalloutMock.MultiStaticResourceItem>{
                    new CalloutMock.MultiStaticResourceItem(
                        tokenResource,
                        'TestGCPGetTokenOk'
                    ),
                    new CalloutMock.MultiStaticResourceItem(
                        eventResource,
                        'TestGCPGetTokenOk'
                    )
                }
            )
        );
    }

    public static String getAttributesResourceUrl(
        SPGeneralSettings genSettings
    ) {
        String optimoveBaseUrl = NamedCredentialsUtil.getOrgDefinedNamedCredential(
                Constants.OPTIMOVE_API_NAMED_CREDENTIALS_NAME,
                '',
                ''
            )
            .credentialUrl;

        return optimoveBaseUrl +
            String.format(
                genSettings.getValue(
                    Constants.OPTIMOVE_GET_ATTRIBUTES_ENDPOINT
                ),
                new List<String>{ 'customerId' }
            );
    }

    public static String getPreferencesResourceUrl(
        SPGeneralSettings genSettings
    ) {
        OptimoveSettingsManager settings = new OptimoveSettingsManager();
        String brandGroupId = settings.getBrandGroupId();

        String optimovePublicBaseUrl = NamedCredentialsUtil.getOrgDefinedNamedCredential(
                Constants.OPTIMOVE_PUBLIC_API_NAMED_CREDENTIALS_NAME,
                '',
                ''
            )
            .credentialUrl;

        return optimovePublicBaseUrl +
            String.format(
                genSettings.getValue(Constants.OPTIMOVE_PREFERENCES_ENDPOINT),
                new List<String>{ brandGroupId, 'customerId' }
            );
    }

    public static String getGCPTokenResourceUrl() {
        return NamedCredentialsUtil.getOrgDefinedNamedCredential(
                Constants.GCP_API_TOKEN_NAMED_CREDENTIALS_NAME,
                '',
                ''
            )
            .credentialUrl;
    }

    public static String getCommLogResourceUrl(
        SPGeneralSettings genSettings,
        OptimoveCommLogFilter filter
    ) {
        String baseUrl = NamedCredentialsUtil.getOrgDefinedNamedCredential(
                Constants.GCP_API_NAMED_CREDENTIALS_NAME,
                '',
                ''
            )
            .credentialUrl;

        return baseUrl +
            String.format(
                genSettings.getValue(
                    Constants.GCP_GET_COMMUNICATION_LOGS_ENDPOINT
                ),
                new List<String>{
                    filter.customerId,
                    CSUtils.formatDate(filter.startDate, 'yyyy-MM-dd'),
                    CSUtils.formatDate(filter.endDate, 'yyyy-MM-dd')
                }
            );
    }

    public static String getChannelInteractionsResourceUrl(
        SPGeneralSettings genSettings,
        OptimoveCommLogFilter filter
    ) {
        String baseUrl = NamedCredentialsUtil.getOrgDefinedNamedCredential(
                Constants.OPTIMOVE_API_NAMED_CREDENTIALS_NAME,
                '',
                ''
            )
            .credentialUrl;

        return baseUrl +
            String.format(
                genSettings.getValue(
                    Constants.OPTIMOVE_GET_CHANNEL_INTERACTIONS_ENDPOINT
                ),
                new List<String>{
                    filter.customerId,
                    CSUtils.formatDate(filter.startDate, 'yyyy-MM-dd'),
                    CSUtils.formatDate(filter.endDate, 'yyyy-MM-dd'),
                    filter.channelId == null
                        ? '0'
                        : String.valueOf(filter.channelId)
                }
            );
    }

    public static String getEventResourceUrl(
        SPGeneralSettings genSettings,
        String eventResourceName
    ) {
        String baseUrl = NamedCredentialsUtil.getOrgDefinedNamedCredential(
                Constants.GCP_API_NAMED_CREDENTIALS_NAME,
                '',
                ''
            )
            .credentialUrl;

        return baseUrl + genSettings.getValue(eventResourceName);
    }

    public static List<GCP_Notification__c> getNotifications(
        Integer count,
        Boolean performDML
    ) {
        List<GCP_Notification__c> notifications = new List<GCP_Notification__c>();

        for (Integer i = 0; i < count; i++) {
            GCP_Notification__c n = getGCPNotifications(11, false);
            n.Status__c = 'Processed';
            notifications.add(n);
        }

        if (performDML)
            insert notifications;

        return notifications;
    }
}
