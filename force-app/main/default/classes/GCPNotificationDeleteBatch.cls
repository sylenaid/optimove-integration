/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-17-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class GCPNotificationDeleteBatch extends DeleteRecordBatch {
    public override String getQuery() {
        return 'SELECT Id ' +
            'FROM GCP_Notification__c ' +
            'WHERE Status__c = \'' +
            OptimoveEventManager.GCP_NOTIFICATION_STATUS_PROCESSED +
            '\'';
    }
}
