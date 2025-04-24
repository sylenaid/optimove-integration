/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-16-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class AsyncJobUtils {
    public final static String STATUS_HOLDING = 'Holding';
    public final static String STATUS_PREPARING = 'Preparing';
    public final static String STATUS_PROCESSING = 'Processing';
    public final static String STATUS_QUEUED = 'Queued';

    public static Boolean isJobClassInStatus(
        String className,
        Set<String> statusNames
    ) {
        return ![
                SELECT Id
                FROM AsyncApexJob
                WHERE ApexClass.Name = :className AND Status IN :statusNames
            ]
            .isEmpty();
    }

    public static Boolean isJobInStatus(Object job, Set<String> statusNames) {
        return isJobClassInStatus(getClassName(job), statusNames);
    }

    public static Boolean isJobClassRunning(String className) {
        Set<String> inProgress = new Set<String>{
            STATUS_HOLDING,
            STATUS_PREPARING,
            STATUS_PROCESSING,
            STATUS_QUEUED
        };
        return isJobInStatus(className, inProgress);
    }

    public static Boolean isJobRunning(Object job) {
        return isJobClassRunning(getClassName(job));
    }

    public static String getClassName(Object o) {
        return String.valueOf(o).split(':')[0];
    }
}
