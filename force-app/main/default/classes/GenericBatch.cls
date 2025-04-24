/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-17-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public abstract with sharing class GenericBatch
        implements Database.Batchable<sObject>,
            Database.Stateful,
            Database.AllowsCallouts {
    Integer depth = 0;
    Boolean allowRunMultiple;
    Boolean executeWhileMore;

    public BatchOrderManager orderManager { get; set; }

    public GenericBatch() {
        this(false, true);
    }

    public GenericBatch(Boolean allowRunMultiple, Boolean executeWhileMore) {
        this.allowRunMultiple = allowRunMultiple;
        this.executeWhileMore = executeWhileMore;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        abortMultiple(bc);

        return Database.getQueryLocator(getQuery());
    }

    public virtual void execute(
        Database.BatchableContext bc,
        List<sObject> scope
    ) {
        execute(scope);
    }

    public void finish(Database.BatchableContext BC) {
        finish();

        executeBatch();
    }

    public void executeBatch() {
        if (
            (depth++ == 0 || (executeWhileMore && !Test.isRunningTest())) &&
            pendingItems() &&
            (allowRunMultiple || !AsyncJobUtils.isJobRunning(this))
        )
            Database.executeBatch(this, this.getBatchSize());
        else if (orderManager != null)
            orderManager.executeNext();
    }

    public virtual Boolean pendingItems() {
        return !Database.query(getQuery() + ' LIMIT 1').isEmpty();
    }

    public virtual Integer getBatchSize() {
        return 200;
    }

    public abstract String getQuery();

    public abstract void execute(List<SObject> scope);

    public virtual void finish() {
    }

    void abortMultiple(Database.BatchableContext bc) {
        if (
            !allowRunMultiple &&
            AsyncJobUtils.isJobInStatus(
                this,
                new Set<String>{ AsyncJobUtils.STATUS_PROCESSING }
            )
        )
            System.abortJob(bc.getJobId());
    }
}
