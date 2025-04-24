/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-03-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveCommLogCtrl {
    @AuraEnabled
    public static List<OptionWrapper> getChannels() {
        try {
            return OptimoveCommLogManager.getChannels();
        } catch (Exception e) {
            throw getError(e);
        }
    }

    @AuraEnabled
    public static List<OptionWrapper> getStatuses() {
        try {
            return OptimoveCommLogManager.getStatuses();
        } catch (Exception e) {
            throw getError(e);
        }
    }

    @AuraEnabled
    public static List<OptimoveCommLogWrapper> getCommLog(
        OptimoveCommLogFilter filter
    ) {
        try {
            OptimoveCommLogManager mng = new OptimoveCommLogManager();

            return mng.getCommLog(filter);
        } catch (Exception e) {
            throw getError(e);
        }
    }

    @AuraEnabled
    public static OptimoveTemplateWrapper getTemplateDetails(
        OptimoveCommLogWrapper log
    ) {
        try {
            OptimoveCommLogManager mng = new OptimoveCommLogManager();

            return mng.getTemplateDetails(log);
        } catch (Exception e) {
            throw getError(e);
        }
    }

    static Exception getError(Exception ex) {
        return ex instanceof LogException
            ? ex
            : LogException.newInstance(
                  Constants.LOGGER_OPTIMOVE_API_CATEGORY,
                  ex
              );
    }
}
