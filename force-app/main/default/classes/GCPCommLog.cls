/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-26-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class GCPCommLog {
    public String CustomerID { get; set; }

    public String ChannelID { get; set; }

    public String TemplateID { get; set; }

    public String TemplateName { get; set; }

    public String ScheduleTime { get; set; }

    public String isMarketingSend { get; set; }

    public Integer channelIdentifier {
        get {
            return Integer.valueOf(ChannelID);
        }
    }

    public Integer templateIdentifier {
        get {
            return Integer.valueOf(TemplateID);
        }
    }

    public Boolean isMarketingEmail {
        get {
            return Boolean.valueOf(isMarketingSend);
        }
    }

    public GCPCommLog() {
    }
}
