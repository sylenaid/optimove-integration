/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-04-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
@isTest
class OptimovePreferenceCalloutTest {
    @isTest
    static void testSuccessGetCustomerPreferences() {
        Test.setMock(
            HttpCalloutMock.class,
            CalloutMock.getStaticResourceSuccessMock(
                'TestOptimoveGetPreferencesOk'
            )
        );

        Test.startTest();

        OptimovePreferenceCallout c = new OptimovePreferenceCallout();
        OptimoveCustomerPreferences preferences = c.getCustomerPreferences(
            'test',
            'test'
        );

        Test.stopTest();

        Assert.isNotNull(preferences, 'Attributes should not be null.');
        Assert.isFalse(
            preferences.channels.isEmpty(),
            'Channels should not be empty.'
        );
        Assert.isFalse(
            preferences.topics.isEmpty(),
            'Topics should not be empty.'
        );
    }

    @isTest
    static void testFailedGetCustomerPreferences() {
        Boolean exceptionThrown = false;

        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());

        Test.startTest();

        try {
            OptimovePreferenceCallout c = new OptimovePreferenceCallout();
            OptimoveCustomerPreferences preferences = c.getCustomerPreferences(
                'test',
                'test'
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
        List<OptimoveTopic> topics = new List<OptimoveTopic>();
        OptimoveTopic t = new OptimoveTopic();
        t.topicId = 'test';
        t.topicName = 'test';
        t.topicDescription = 'test';
        t.channelSubscription = new List<Integer>{ 1, 2, 3 };
        topics.add(t);

        Test.startTest();

        OptimovePreferenceCallout c = new OptimovePreferenceCallout();
        c.updateCustomerPreferences('test', 'test', topics);

        Test.stopTest();

        Assert.isTrue(true, 'Preferences updated.');
    }

    @isTest
    static void testFailedUpdatePreferences() {
        Boolean exceptionThrown = false;

        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());

        List<OptimoveTopic> topics = new List<OptimoveTopic>();
        OptimoveTopic t = new OptimoveTopic();
        t.topicId = 'test';
        t.topicName = 'test';
        t.topicDescription = 'test';
        t.channelSubscription = new List<Integer>{ 1, 2, 3 };
        topics.add(t);

        Test.startTest();

        try {
            OptimovePreferenceCallout c = new OptimovePreferenceCallout();
            c.updateCustomerPreferences('test', 'test', topics);
            Assert.fail('Exception should be thown.');
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Test.stopTest();

        Assert.isTrue(exceptionThrown, 'Exception should be thrown.');
    }
}
