/**
 * @description       : 
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             : 
 * @last modified on  : 09-10-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
**/
trigger OptimoveEvent on Optimove_Event__e (after insert) {
    new OptimoveEventTriggerHandler().run();
}