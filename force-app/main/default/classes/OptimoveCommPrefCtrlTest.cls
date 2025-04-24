/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-03-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
@isTest
class OptimoveCommPrefCtrlTest {
    @isTest
    static void testSuccessGetPreferences() {
        OptimoveTestData.setGetPreferencesCalloutMocks();

        Test.startTest();

        OptimovePreferenceWrapper w = OptimoveCommPrefCtrl.getPreferences(
            'customerId'
        );

        Test.stopTest();

        Assert.isNotNull(w.general, 'General topic can not be null.');
        Assert.isNotNull(w.topics, 'Topics can not be null.');
        Assert.isFalse(w.topics.isEmpty(), 'Topics can not be empty.');
    }

    @isTest
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

        List<OptimoveTopicWrapper> preferences = OptimoveTestData.getPreferences(true);

        Test.startTest();

        OptimoveCommPrefCtrl.updatePreferences('customerId', preferences);

        Test.stopTest();

        Assert.isTrue(true, 'Preferences updated');
    }

    @isTest
    static void testFailedUpdatePreferences() {
        Boolean exceptionThrown = false;

        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());

        List<OptimoveTopicWrapper> preferences = OptimoveTestData.getPreferences(false);

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
}
