/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 08-20-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveAttribute {
    public String RealFieldName { get; set; }

    public String Alias { get; set; }

    public String FieldType { get; set; }

    public String Value { get; set; }

    public OptimoveAttribute() {
    }

    public OptimoveAttribute(OptimoveChannelWrapper chW) {
        RealFieldName = chW.name;
        Value = String.valueOf(chW.optIn);
    }
}
