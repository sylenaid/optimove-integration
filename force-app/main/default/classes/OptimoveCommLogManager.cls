/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-03-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveCommLogManager {
    OptimoveCommLogCallout omCallout;
    OptimoveTransactionalCommLogCallout omTransCallout;
    GCPCommLogCallout gcpCallout;
    OptimoveSettingsManager settings;
    Map<Integer, String> enabledChannels;
    Map<Integer, String> status;

    public OptimoveCommLogManager() {
        settings = new OptimoveSettingsManager();
        omCallout = new OptimoveCommLogCallout();
        omTransCallout = new OptimoveTransactionalCommLogCallout();
        enabledChannels = settings.getEnabledChannels();
        status = settings.getDeliverabilityStatuses();
    }

    public static List<OptionWrapper> getChannels() {
        return getOptions(new OptimoveSettingsManager().getEnabledChannels());
    }

    public static List<OptionWrapper> getStatuses() {
        return getOptions(
            new OptimoveSettingsManager().getDeliverabilityStatuses()
        );
    }

    public List<OptimoveCommLogWrapper> getCommLog(
        OptimoveCommLogFilter filter
    ) {
        gcpCallout = new GCPCommLogCallout();
        List<OptimoveCommLogWrapper> result = new List<OptimoveCommLogWrapper>();
        List<GCPCommLog> gcpLog = gcpCallout.getCommLogs(filter);

        if (gcpLog.isEmpty())
            return result;

        Map<String, OptimoveChannelInteraction> interactions = getInteractions(
            filter
        );

        for (GCPCommLog log : gcpLog) {
            if (!isChannelEnabled(log.channelIdentifier))
                continue;

            OptimoveCommLogWrapper w = new OptimoveCommLogWrapper(log);
            w.channel = enabledChannels.get(w.channelId);
            setInteraction(w, interactions);

            result.add(w);
        }

        return result;
    }

    public OptimoveTemplateWrapper getTemplateDetails(
        OptimoveCommLogWrapper log
    ) {
        List<OptimoveTemplate> templates = log.isMarketingSend
            ? omCallout.getTemplates(log.channelId, log.templateId, log.subject)
            : omTransCallout.getTemplates();

        return getTemplate(log, templates);
    }

    Boolean isChannelEnabled(Integer channelId) {
        return enabledChannels.containsKey(channelId);
    }

    Map<String, OptimoveChannelInteraction> getInteractions(
        OptimoveCommLogFilter filter
    ) {
        Map<String, OptimoveChannelInteraction> result = new Map<String, OptimoveChannelInteraction>();

        for (Integer channelId : enabledChannels.keySet()) {
            filter.channelId = channelId;

            List<OptimoveChannelInteraction> interactions = omCallout.getChannelInteractions(
                filter
            );

            for (OptimoveChannelInteraction chInt : interactions)
                result.put(
                    getInteractionKey(chInt.ChannelID, chInt.TemplateID),
                    chInt
                );
        }

        return result;
    }

    void setInteraction(
        OptimoveCommLogWrapper w,
        Map<String, OptimoveChannelInteraction> interactions
    ) {
        if (!w.isMarketingSend)
            return;

        w.statusId = interactions.get(
                getInteractionKey(w.channelId, w.templateId)
            )
            ?.EventID;
        w.status = status.get(w.statusId) ?? 'Sent';
    }

    String getInteractionKey(Integer channelId, Integer templateId) {
        return channelId + '|' + templateId;
    }

    OptimoveTemplateWrapper getTemplate(
        OptimoveCommLogWrapper log,
        List<OptimoveTemplate> templates
    ) {
        for (OptimoveTemplate t : templates)
            if (t.TemplateID == log.templateId)
                return new OptimoveTemplateWrapper(t);

        throw new SPException(
            'Unable to retrive template (ID: ' + log.templateId + ')'
        );
    }

    static List<OptionWrapper> getOptions(Map<Integer, String> options) {
        List<OptionWrapper> result = new List<OptionWrapper>();

        for (Integer optionId : options.keySet())
            result.add(new OptionWrapper(options.get(optionId), optionId));

        result.sort();

        return result;
    }
}
