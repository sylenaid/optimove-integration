/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-27-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptionWrapper implements Comparable {
    @AuraEnabled
    public String label { get; set; }

    @AuraEnabled
    public String value { get; set; }

    public OptionWrapper() {
    }

    public OptionWrapper(String label, String value) {
        this.label = label;
        this.value = value;
    }

    public OptionWrapper(String label, Integer value) {
        this.label = label;
        this.value = String.valueOf(value);
    }

    public Integer compareTo(Object compareTo) {
        OptionWrapper other = (OptionWrapper) compareTo;

        if (value > other.value)
            return 1;
        else if (value < other.value)
            return -1;
        return 0;
    }
}
