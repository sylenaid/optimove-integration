/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 08-26-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getRecord } from "lightning/uiRecordApi";
import getPreferences from "@salesforce/apex/OptimoveCommPrefCtrl.getPreferences";
import updatePreferences from "@salesforce/apex/OptimoveCommPrefCtrl.updatePreferences";
import LightningConfirm from "lightning/confirm";

const FIELDS = {
    Lead: "Lead.fxTrade_One_Id__c",
    Account: "Account.One_Id__c",
    fxAccount__c: "fxAccount__c.fxTrade_One_Id__c"
};

export default class OptimoveCommPref extends LightningElement {
    @api recordId;
    @api objectApiName;
    customerId;
    field;
    loading;
    loaded;
    cols;
    preferences;
    pendingChanges;
    changes = [];

    connectedCallback() {
        this.field = FIELDS[this.objectApiName];
    }

    @wire(getRecord, { recordId: "$recordId", fields: "$field" })
    wiredRecord({ error, data }) {
        if (error) {
            let message = "Unknown error";

            if (Array.isArray(error.body)) {
                message = error.body.map((e) => e.message).join(", ");
            } else if (typeof error.body.message === "string") {
                message = error.body.message;
            }

            this.showError("Error", message);
        } else if (data) {
            if (this.objectApiName == "Account")
                this.customerId = data.fields.One_Id__c.value;
            else if (this.objectApiName == "Lead")
                this.customerId = data.fields.fxTrade_One_Id__c.value;
            else this.customerId = data.fields.fxTrade_One_Id__c.value;
        }
    }

    handleRetrieve() {
        this.loading = true;

        getPreferences({
            customerId: this.customerId
        })
            .then((preferences) => {
                if (preferences !== null) {
                    this.preferences = preferences;
                    this.cols = preferences.general.channels.length + 1;
                    this.loaded = true;
                } else {
                    this.showError("Error", "Empty preferences.");
                }

                this.loading = false;
            })
            .catch((error) => {
                this.loading = false;

                this.showError(
                    "Error retriving preferences",
                    error.body.message
                );
            });
    }

    handleChange(event) {
        const uniqueId = event.target.name;
        const channelChanged = (channel) => channel.uniqueId == uniqueId;

        let genCh = this.preferences.general.channels.find(channelChanged);

        if (genCh) genCh.optIn = event.target.checked;
        else
            for (let i = 0; i < this.preferences.topics.length; i++) {
                let topic = this.preferences.topics[i];
                let tCh = topic.channels.find(channelChanged);

                if (tCh) {
                    tCh.optIn = event.target.checked;
                    break;
                }
            }

        if (this.changes.includes(uniqueId))
            this.changes = this.changes.filter((change) => change != uniqueId);
        else this.changes.push(uniqueId);

        this.pendingChanges = this.changes.length > 0;
    }

    async handleConfirm() {
        const result = await LightningConfirm.open({
            message:
                "Are you sure you want to update preferences" +
                " in Optimove for current customer?",
            variant: "headerless",
            label: "this is the aria-label value"
        });

        if (result) {
            this.updatePreferences();
        }
    }

    updatePreferences() {
        this.loading = true;

        updatePreferences({
            customerId: this.customerId,
            preferences: this.getChangedPreferences()
        })
            .then(() => {
                this.loading = false;
                this.pendingChanges = false;
                this.changes = [];
                this.showSuccess("Preferences update requested successfully.");
            })
            .catch((error) => {
                this.loading = false;

                this.showError(
                    "Error updating preferences",
                    error.body.message
                );
            });
    }

    getChangedPreferences() {
        let result = [];
        const channelChanged = (channel) =>
            this.changes.includes(channel.uniqueId);

        if (this.preferences.general.channels.some(channelChanged))
            result.push(this.preferences.general);

        result = result.concat(
            this.preferences.topics.filter((topic) =>
                topic.channels.some(channelChanged)
            )
        );

        return result;
    }

    showError(title, msg) {
        const event = new ShowToastEvent({
            title: title,
            message: msg,
            variant: "error"
        });
        this.dispatchEvent(event);
    }

    showSuccess(msg) {
        const event = new ShowToastEvent({
            title: "Success",
            message: msg,
            variant: "success"
        });
        this.dispatchEvent(event);
    }
}
