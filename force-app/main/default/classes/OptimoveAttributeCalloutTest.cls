/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-04-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
@isTest
class OptimoveAttributeCalloutTest {
    @isTest
    static void testSuccessGetAttributes() {
        Test.setMock(
            HttpCalloutMock.class,
            CalloutMock.getStaticResourceSuccessMock(
                'TestOptimoveGetAttributesOk'
            )
        );

        Test.startTest();

        OptimoveAttributeCallout c = new OptimoveAttributeCallout();
        List<OptimoveAttribute> attributes = c.getCustomerAttributes('test');

        Test.stopTest();

        Assert.isNotNull(attributes, 'Attributes should not be null.');
        Assert.isFalse(attributes.isEmpty(), 'Attributes should not be empty.');
    }

    @isTest
    static void testFailedGetAttributes() {
        Boolean exceptionThrown = false;

        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());

        Test.startTest();

        try {
            OptimoveAttributeCallout c = new OptimoveAttributeCallout();
            List<OptimoveAttribute> attributes = c.getCustomerAttributes(
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
    static void testSuccessUpdateAttributes() {
        Test.setMock(HttpCalloutMock.class, CalloutMock.getOkMock());

        OptimoveAttribute att = new OptimoveAttribute();
        att.RealFieldName = 'test';
        att.Alias = 'test';
        att.FieldType = 'test';

        OptimoveCustomerAttribute cAtt = new OptimoveCustomerAttribute();
        cAtt.CustomerId = 'test';
        cAtt.Attributes.add(att);

        OptimoveMultipleCustomerAttributes m = new OptimoveMultipleCustomerAttributes();
        m.CustomerNewAttributesValuesList.add(cAtt);
        m.CallbackURL = 'test';

        Test.startTest();

        OptimoveAttributeCallout c = new OptimoveAttributeCallout();
        c.updateCustomerAttributes(m);

        Test.stopTest();

        Assert.isTrue(true, 'Attributes updated.');
    }

    @isTest
    static void testFailedUpdateAttributes() {
        Boolean exceptionThrown = false;

        Test.setMock(HttpCalloutMock.class, CalloutMock.getErrorMock());

        OptimoveAttribute att = new OptimoveAttribute();
        att.RealFieldName = 'test';
        att.Value = 'false';

        OptimoveCustomerAttribute cAtt = new OptimoveCustomerAttribute();
        cAtt.CustomerId = 'test';
        cAtt.Attributes.add(att);

        OptimoveMultipleCustomerAttributes m = new OptimoveMultipleCustomerAttributes();
        m.CustomerNewAttributesValuesList.add(cAtt);

        Test.startTest();

        try {
            OptimoveAttributeCallout c = new OptimoveAttributeCallout();
            c.updateCustomerAttributes(m);
            Assert.fail('Exception should be thown.');
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Test.stopTest();

        Assert.isTrue(exceptionThrown, 'Exception should be thrown.');
    }
}
