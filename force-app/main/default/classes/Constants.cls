/**
 * @description       : 
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             : 
 * @last modified on  : 09-09-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
**/
public with sharing class Constants 
{
    public static final String LOGGER_OPTIMOVE_API_CATEGORY = 'Optimove-API-Integration';
    public static final String LOGGER_GCP_API_CATEGORY = 'GCP-API-Integration';

    public static final String OPTIMOVE_GET_ATTRIBUTES_ENDPOINT = 'Optimove_Api_Get_Attributes_Endpoint';
    public static final String OPTIMOVE_UPDATE_ATTRIBUTES_ENDPOINT = 'Optimove_Api_Update_Attributes_Endpoint';
    public static final String OPTIMOVE_PREFERENCES_ENDPOINT = 'Optimove_Api_Preferences_Endpoint';
    public static final String OPTIMOVE_GET_CHANNEL_INTERACTIONS_ENDPOINT = 'Optimove_Api_Channel_Interact_Endpoint';
    public static final String OPTIMOVE_GET_MARKETING_TEMPLATE_ENDPOINT = 'Optimove_Api_Marketing_Template_Endpoint';
    public static final String OPTIMOVE_GET_TRANSACTIONAL_TEMPLATE_ENDPOINT = 'Optimove_Api_Transact_Template_Endpoint';
    public static final String OPTIMOVE_CHECK_PREFERENCE_CHANNELS = 'Optimove_Check_Preference_Channels';
    public static final String OPTIMOVE_CALLBACK_SITE_NAME = 'Optimove_Callback_Site_Name';

    public static final String GCP_NOTIFY_EVENT11_ENDPOINT = 'GCP_Api_Event11_Endpoint';
    public static final String GCP_NOTIFY_EVENT13_ENDPOINT = 'GCP_Api_Event13_Endpoint';
    public static final String GCP_GET_COMMUNICATION_LOGS_ENDPOINT = 'GCP_Api_Get_Communication_Logs_Endpoint';
    public static final String GCP_NOTIFICATION_ATTEMPTS_LIMIT = 'GCP_Notification_Attempts_Limit';
    public static final String OPTIMOVE_API_NAMED_CREDENTIALS_NAME = 'Optimove_API';
    public static final String OPTIMOVE_TRANSACTIONAL_API_NAMED_CREDENTIALS_NAME = 'Optimove_Transactional_API';
    public static final String OPTIMOVE_PUBLIC_API_NAMED_CREDENTIALS_NAME = 'Optimove_Public_API';
    public static final String GCP_API_NAMED_CREDENTIALS_NAME = 'GCP_API';
    public static final String GCP_API_TOKEN_NAMED_CREDENTIALS_NAME = 'GCP_API_Token';
    public static final String GCP_API_EXTERNAL_CREDENTIAL_NAME = 'GCP_API';
}