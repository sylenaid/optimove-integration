/**
 * @description       : 
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             : 
 * @last modified on  : 08-15-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
**/
public with sharing class OptimoveCustomerPreferences {
    public List<OptimoveTopic> topics { get; set; }

    public List<Integer> channels { get; set; }

    public OptimoveCustomerPreferences() {
    }
}
