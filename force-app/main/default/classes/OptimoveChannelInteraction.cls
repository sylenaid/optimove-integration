/**
 * @description       : 
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             : 
 * @last modified on  : 09-08-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
**/
public with sharing class OptimoveChannelInteraction {
    public String InteractionDate { get; set; }

    public Integer CampaignID { get; set; }

    public Integer RecipientGroupID { get; set; }

    public Integer ActionID { get; set; }

    public Integer ChannelID { get; set; }

    public Integer TemplateID { get; set; }

    public Integer EventID { get; set; }

    public OptimoveChannelInteraction() {
    }

    public static Map<String, String> getPropertyMappings() {
        return new Map<string, string> {
            'Date' => 'InteractionDate'
        };
    }
}
