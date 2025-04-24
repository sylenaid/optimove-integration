/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-23-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveEventManager {
    public static final String GCP_NOTIFICATION_STATUS_PENDING = 'Pending';
    public static final String GCP_NOTIFICATION_STATUS_PROCESSED = 'Processed';
    public static final String GCP_NOTIFICATION_STATUS_FAILED = 'Failed';
    Integer gcpNotifAttemptsLimit = 2;

    public OptimoveEventManager() {
        String limitString = SPGeneralSettings.getInstance()
            .getValue(Constants.GCP_NOTIFICATION_ATTEMPTS_LIMIT);

        if (String.isNotEmpty(limitString) && limitString.isNumeric())
            gcpNotifAttemptsLimit = Integer.valueOf(limitString);
    }

    public void sendGCPNotifications(List<GCP_Notification__c> notifications) {
        Integer i = 0;

        try {
            GCPEventCallout c = new GCPEventCallout();

            for (; i < notifications.size(); i++) {
                GCP_Notification__c notification = notifications[i];

                try {
                    if (notification.Optimove_Event_Type_Id__c == 11)
                        c.notifyEvent11(notification.Optimove_Event_Payload__c);
                    else if (notification.Optimove_Event_Type_Id__c == 13)
                        c.notifyEvent13(notification.Optimove_Event_Payload__c);

                    notification.Status__c = GCP_NOTIFICATION_STATUS_PROCESSED;
                } catch (Exception ex) {
                    onError(ex, notification);
                }
            }
        } catch (Exception ex) {
            for (; i < notifications.size(); i++)
                onError(ex, notifications[i]);
        } finally {
            Database.update(notifications);
        }
    }

    /**
     * @description Publish platform event inmideatly
     * to notify Optimove received event.
     * @author SkyPlanner - Dianelys Velazquez | 09-17-2024
     * @param eventTypeId
     * @param eventPayload
     **/
    public void processEvent(Integer eventTypeId, String eventPayload) {
        Optimove_Event__e event = new Optimove_Event__e();
        event.Type_Id__c = eventTypeId;
        event.Payload__c = eventPayload;

        Database.SaveResult result = EventBus.publish(event);

        if (!result.isSuccess())
            for (Database.Error err : result.getErrors())
                Logger.error(
                    'Error publishing Optimove Event ' + eventTypeId,
                    Constants.LOGGER_OPTIMOVE_API_CATEGORY,
                    'Error: ' + err.getStatusCode() + ' - ' + err.getMessage()
                );
    }

    /**
     * @description Create GCP_Notification__c records
     * from received Optimove_Event__e platform events.
     * @author SkyPlanner - Dianelys Velazquez | 09-17-2024
     * @param events
     **/
    public void processEvents(List<Optimove_Event__e> events) {
        List<GCP_Notification__c> gcpNotifications = new List<GCP_Notification__c>();

        for (Optimove_Event__e event : events)
            gcpNotifications.add(
                new GCP_Notification__c(
                    Optimove_Event_Type_Id__c = event.Type_Id__c,
                    Optimove_Event_Payload__c = event.Payload__c
                )
            );

        DataBase.SaveResult[] saveResults = Database.insert(
            gcpNotifications,
            false
        );

        logErrors(saveResults);
        scheduleGCPNotificationBatches();
    }

    public void scheduleGCPNotificationBatches() {
        BatchOrderManager mng = new BatchOrderManager(
            new List<GenericBatch>{
                new GCPNotificationBatch(),
                new GCPNotificationDeleteBatch()
            }
        );
        mng.executeNext();
    }

    void logErrors(List<Database.SaveResult> saveResults) {
        for (Database.SaveResult sr : saveResults) {
            if (!sr.isSuccess()) {
                for (Database.Error err : sr.getErrors()) {
                    Logger.error(
                        'Error inserting GCP Notification',
                        Constants.LOGGER_OPTIMOVE_API_CATEGORY,
                        'Error: ' +
                            err.getStatusCode() +
                            ' - ' +
                            err.getMessage()
                    );
                }
            }
        }
    }

    void onError(Exception ex, GCP_Notification__c n) {
        n.Attempts__c++;
        n.Error_Message__c = ex.getMessage();

        if (n.Attempts__c >= gcpNotifAttemptsLimit)
            n.Status__c = GCP_NOTIFICATION_STATUS_FAILED;
    }
}
