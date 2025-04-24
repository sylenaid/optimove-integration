/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-17-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class GCPNotificationBatch extends GenericBatch {
    public override Integer getBatchSize() {
        return 1;
    }

    public override String getQuery() {
        return 'SELECT Optimove_Event_Type_Id__c, ' +
            'Optimove_Event_Payload__c, ' +
            'Status__c, ' +
            'Attempts__c, ' +
            'Error_Message__c ' +
            'FROM GCP_Notification__c ' +
            'WHERE Status__c = \'' +
            OptimoveEventManager.GCP_NOTIFICATION_STATUS_PENDING +
            '\'';
    }

    public override void execute(List<SObject> scope) {
        OptimoveEventManager mng = new OptimoveEventManager();
        mng.sendGCPNotifications((List<GCP_Notification__c>) scope);
    }
}
