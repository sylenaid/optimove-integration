/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-27-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveSettingsManager {
    public static final String OPTIMOVE_SETTING_TYPE_CHANNEL = 'Channel';
    public static final String OPTIMOVE_SETTING_TYPE_BRAND_GROUP = 'Brand Group';
    public static final String OPTIMOVE_SETTING_TYPE_DELIVERABILITY_STATUS = 'Deliverability Status';

    public List<Optimove_Settings__mdt> getChannelSettigs() {
        return getSettingsByType(OPTIMOVE_SETTING_TYPE_CHANNEL);
    }

    public List<Optimove_Settings__mdt> getDeliverabilityStatusSettigs() {
        return getSettingsByType(OPTIMOVE_SETTING_TYPE_DELIVERABILITY_STATUS);
    }

    public List<Optimove_Settings__mdt> getSettingsByType(String type) {
        return [
            SELECT MasterLabel, DeveloperName, External_Id__c
            FROM Optimove_Settings__mdt
            WHERE Type__c = :type AND Enabled__c = TRUE
        ];
    }

    public String getBrandGroupId() {
        String env = Util.getValidCredentialSuffix(); // sample: _DEV
        return getBrandGroupId(env);
    }

    public String getBrandGroupId(String env) {
        String brandGroupSettingName = 'Brand_Group_Id' + env;

        List<Optimove_Settings__mdt> settings = [
            SELECT External_Id__c
            FROM Optimove_Settings__mdt
            WHERE
                Type__c = :OPTIMOVE_SETTING_TYPE_BRAND_GROUP
                AND DeveloperName = :brandGroupSettingName
        ];

        return settings.isEmpty() ? null : settings[0].External_Id__c;
    }

    public Boolean checkPreferenceChannels() {
        return SPGeneralSettings.getInstance()
                .getValue(Constants.OPTIMOVE_CHECK_PREFERENCE_CHANNELS) ==
            'true';
    }

    public String getCallbackBaseUrl() {
        String siteName = SPGeneralSettings.getInstance()
            .getValue(Constants.OPTIMOVE_CALLBACK_SITE_NAME);

        List<Site> sites = [SELECT Id FROM Site WHERE Name = :siteName];

        if (sites.isEmpty())
            return null;

        List<SiteDetail> siteDetails = [
            SELECT SecureURL
            FROM SiteDetail
            WHERE DurableId = :sites[0].Id
        ];

        return siteDetails.isEmpty() ? null : siteDetails[0].SecureURL;
    }

    public String getCallbackUrl() {
        String callbackBaseUrl = getCallbackBaseUrl();

        if (String.isBlank(callbackBaseUrl))
            return null;

        return callbackBaseUrl + 'services/apexrest/optimove/attr/callback';
    }

    public Map<Integer, String> getEnabledChannels() {
        Map<Integer, String> result = new Map<Integer, String>();

        for (Optimove_Settings__mdt s : getChannelSettigs())
            result.put(Integer.valueOf(s.External_Id__c), s.MasterLabel);

        return result;
    }

    public Map<Integer, String> getDeliverabilityStatuses() {
        Map<Integer, String> result = new Map<Integer, String>();

        for (Optimove_Settings__mdt s : getDeliverabilityStatusSettigs())
            result.put(Integer.valueOf(s.External_Id__c), s.MasterLabel);

        return result;
    }
}
