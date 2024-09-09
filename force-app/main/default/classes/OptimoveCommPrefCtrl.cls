/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 08-21-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveCommPrefCtrl {
    @AuraEnabled
    public static OptimovePreferenceWrapper getPreferences(String customerId) {
        try {
            OptimoveCommPrefManager mng = new OptimoveCommPrefManager();

            return mng.getPreferences(customerId);
        } catch (Exception e) {
            throw getError(e);
        }
    }

    @AuraEnabled
    public static void updatePreferences(
        String customerId,
        List<OptimoveTopicWrapper> preferences
    ) {
        try {
            OptimoveCommPrefManager mng = new OptimoveCommPrefManager();

            mng.updatePreferences(customerId, preferences);
        } catch (Exception e) {
            throw getError(e);
        }
    }

    static Exception getError(Exception ex) {
        return ex instanceof LogException 
            ? ex 
            : LogException.newInstance(
                Constants.LOGGER_OPTIMOVE_API_CATEGORY, ex);
    }
}
