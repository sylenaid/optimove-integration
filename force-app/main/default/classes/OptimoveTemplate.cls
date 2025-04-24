/**
 * @description       : 
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             : 
 * @last modified on  : 09-08-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
**/
public with sharing class OptimoveTemplate {
    public Integer TemplateID { get; set; }

    public String TemplateName { get; set; }

    public String TemplateContent { get; set; }

    public List<String> TemplateAttributes { get; set; }

    public OptimoveTemplate() {
    }
}
