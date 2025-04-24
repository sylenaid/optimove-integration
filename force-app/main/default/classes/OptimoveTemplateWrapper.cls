/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-01-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveTemplateWrapper {
    @AuraEnabled
    public Integer templateId { get; set; }

    @AuraEnabled
    public String name { get; set; }

    @AuraEnabled
    public String content { get; set; }

    @AuraEnabled
    public List<String> templateAttributes { get; set; }

    public OptimoveTemplateWrapper() {
    }

    public OptimoveTemplateWrapper(OptimoveTemplate t) {
        templateId = t.TemplateID;
        name = t.templateAttributes != null &&
            t.templateAttributes.size() >= 3 &&
            String.isBlank(t.TemplateName)
            ? t.templateAttributes[2]
            : t.TemplateName;
        content = t.TemplateContent;
        templateAttributes = t.TemplateAttributes;
    }
}
