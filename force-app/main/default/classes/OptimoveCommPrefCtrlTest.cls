/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-04-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
@isTest
class OptimoveCommPrefCtrlTest {
    @IsTest
    static void testSuccessGetPreferences() {
        setGetPreferencesCalloutMocks();

        Test.startTest();

        OptimovePreferenceWrapper w = OptimoveCommPrefCtrl.getPreferences(
            'customerId'
        );

        Test.stopTest();

        Assert.isNotNull(w.general, 'General topic can not be null.');
        Assert.isNotNull(w.topics, 'Topics can not be null.');
        Assert.isFalse(w.topics.isEmpty(), 'Topics can not be empty.');
    }

    @IsTest
    static void testFailedGetPreferences() {
        Boolean exceptionThrown = false;

        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());

        Test.startTest();

        try {
            OptimovePreferenceWrapper w = OptimoveCommPrefCtrl.getPreferences(
                'customerId'
            );

            Assert.fail('Exception should be thrown.');
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Test.stopTest();

        Assert.isTrue(exceptionThrown, 'Exception should be thrown.');
    }

    @isTest
    static void testSuccessUpdatePreferences() {
        Test.setMock(HttpCalloutMock.class, CalloutMock.getOkMock());

        List<OptimoveTopicWrapper> preferences = getPreferences(true);

        Test.startTest();

        OptimoveCommPrefCtrl.updatePreferences('customerId', preferences);

        Test.stopTest();

        Assert.isTrue(true, 'Preferences updated');
    }

    @isTest
    static void testFailedUpdatePreferences() {
        Boolean exceptionThrown = false;

        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());

        List<OptimoveTopicWrapper> preferences = getPreferences(false);

        Test.startTest();

        try {
            OptimoveCommPrefCtrl.updatePreferences('customerId', preferences);

            Assert.fail('Exception should be thrown.');
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Test.stopTest();

        Assert.isTrue(exceptionThrown, 'Exception should be thrown.');
    }

    static void setGetPreferencesCalloutMocks() {
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

    static String getAttributesResourceUrl(SPGeneralSettings genSettings) {
        String optimoveBaseUrl =
            NamedCredentialsUtil.getOrgDefinedNamedCredential(
                Constants.OPTIMOVE_API_NAMED_CREDENTIALS_NAME,
                '',
                ''
            ).credentialUrl;

        return optimoveBaseUrl +
            String.format(
                genSettings.getValue(
                    Constants.OPTIMOVE_GET_ATTRIBUTES_ENDPOINT
                ),
                new List<String>{ 'customerId' }
            );
    }

    static String getPreferencesResourceUrl(SPGeneralSettings genSettings) {
        OptimoveSettingsManager settings = new OptimoveSettingsManager();
        String brandGroupId = settings.getBrandGroupId();

        String optimovePublicBaseUrl =
            NamedCredentialsUtil.getOrgDefinedNamedCredential(
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

    static List<OptimoveTopicWrapper> getPreferences(
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
}
