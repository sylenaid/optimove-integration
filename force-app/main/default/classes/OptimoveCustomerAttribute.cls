/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 08-19-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveCustomerAttribute {
    public String CustomerId { get; set; }

    public List<OptimoveAttribute> Attributes { get; set; }

    public OptimoveCustomerAttribute() {
        Attributes = new List<OptimoveAttribute>();
    }
}
