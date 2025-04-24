/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-17-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveEventTriggerHandler extends TriggerHandler {
    OptimoveEventManager manager;
    List<Optimove_Event__e> newList;

    public OptimoveEventTriggerHandler() {
        newList = Trigger.new;
        manager = new OptimoveEventManager();
    }

    public override void afterInsert() {
        manager.processEvents(newList);
    }
}
