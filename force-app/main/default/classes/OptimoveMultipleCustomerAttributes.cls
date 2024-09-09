/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 08-20-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveMultipleCustomerAttributes {
    public String CallbackURL { get; set; }

    public List<OptimoveCustomerAttribute> CustomerNewAttributesValuesList {
        get;
        set;
    }

    public OptimoveMultipleCustomerAttributes() {
        CustomerNewAttributesValuesList = new List<OptimoveCustomerAttribute>();
    }
}
