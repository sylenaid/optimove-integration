/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-19-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class BatchOrderManager {
    List<GenericBatch> batchQueue;

    public BatchOrderManager(List<GenericBatch> batchQueue) {
        this.batchQueue = batchQueue;
    }

    public void executeNext() {
        if (batchQueue.isEmpty())
            return;

        GenericBatch next = batchQueue.remove(0);
        next.orderManager = this;
        next.executeBatch();
    }
}
