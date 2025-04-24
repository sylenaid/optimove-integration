/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 10-04-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getRecord } from "lightning/uiRecordApi";
import OptimoveCommLogPreview from "c/optimoveCommLogPreview";
import getChannels from "@salesforce/apex/OptimoveCommLogCtrl.getChannels";
import getStatuses from "@salesforce/apex/OptimoveCommLogCtrl.getStatuses";
import getCommLog from "@salesforce/apex/OptimoveCommLogCtrl.getCommLog";
import getTemplateDetails from "@salesforce/apex/OptimoveCommLogCtrl.getTemplateDetails";

const FIELDS = {
    Lead: "Lead.fxTrade_One_Id__c",
    Account: "Account.One_Id__c",
    fxAccount__c: "fxAccount__c.fxTrade_One_Id__c"
};

const columns = [
    {
        label: "Channel",
        fieldName: "channel",
        hideDefaultActions: true,
        sortable: true,
        initialWidth: 100
    },
    {
        label: "Subject",
        fieldName: "subject",
        hideDefaultActions: true,
        wrapText: true,
        sortable: false,
        type: "template",
        typeAttributes: {
            body: {
                fieldName: "templateBody"
            }
        }
    },
    {
        label: "Date Sent",
        fieldName: "dateSent",
        type: "date",
        typeAttributes: {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit"
        },
        hideDefaultActions: true,
        sortable: true
    },
    {
        label: "Deliverability Status",
        fieldName: "status",
        hideDefaultActions: true,
        sortable: true,
        initialWidth: 165
    },
    {
        label: "Preview",
        type: "button-icon",
        initialWidth: 80,
        typeAttributes: {
            name: "preview",
            iconName: "action:preview",
            title: "Preview",
            variant: "border-filled",
            alternativeText: "Preview"
        }
    }
];

export default class OptimoveCommLog extends LightningElement {
    @api recordId;
    @api objectApiName;
    customerId;
    emptyCustomer = true;
    field;
    loading;
    loaded;

    columns = columns;
    defaultSortDirection = "asc";
    sortDirection = "asc";
    sortedBy;

    startDate;
    endDate;
    minDate;
    maxDate;
    retrievedStartDate;
    retrievedEndDate;

    retrievedLogs = [];
    commLogs = [];
    channels = [];
    selectedChannel;
    statuses = [];
    selectedStatus;
    filterSubject = "";
    cleanFilters = false;

    connectedCallback() {
        this.field = FIELDS[this.objectApiName];
        var today = new Date();
        var start = new Date();
        start.setDate(today.getDate() - 90);
        this.startDate = start.toISOString().split("T")[0];
        this.endDate = today.toISOString().split("T")[0];
        this.minDate = start.toISOString().split("T")[0];
        this.maxDate = today.toISOString().split("T")[0];

        this.getChannels();
        this.getStatuses();
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

            this.emptyCustomer = !this.customerId;
        }
    }

    handleStartDateChange(event) {
        if (event.target.reportValidity()) this.startDate = event.target.value;

        this.checkFilterChanges();
    }

    handleEndDateChange(event) {
        if (event.target.reportValidity()) this.endDate = event.target.value;

        this.checkFilterChanges();
    }

    handleSubjectChange(e) {
        this.filterSubject = e.detail.value;

        this.filterLogs();
    }

    handleChannelChange(e) {
        this.selectedChannel = e.detail.value;

        this.filterLogs();
    }

    handleStatusChange(e) {
        this.selectedStatus = e.detail.value;

        this.filterLogs();
    }

    handleClearFilter() {
        this.filterSubject = "";
        this.selectedChannel = null;
        this.selectedStatus = null;

        this.filterLogs();
    }

    handleRowAction(e) {
        const action = e.detail.action;
        const row = e.detail.row;
        switch (action.name) {
            case "preview":
                this.previewCommLog(row);
                break;
        }
    }

    handleRetrieve() {
        this.loading = true;

        getCommLog({
            filter: {
                customerId: this.customerId,
                startDate: this.startDate,
                endDate: this.endDate
            }
        })
            .then((commLogs) => {
                if (commLogs !== null) {
                    this.retrievedLogs = commLogs;
                    this.commLogs = [...commLogs];
                    this.retrievedStartDate = this.startDate;
                    this.retrievedEndDate = this.endDate;
                    this.loaded = true;
                } else {
                    this.showError("Error", "Empty preferences.");
                }

                this.loading = false;
            })
            .catch((error) => {
                this.loading = false;

                this.showError(
                    "Error retriving communication log",
                    error.body.message
                );
            });
    }

    handleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;

        this.sortLogs();
    }

    sortLogs() {
        const cloneData = [...this.commLogs];
        cloneData.sort(
            this.sortBy(this.sortedBy, this.sortDirection === "asc" ? 1 : -1)
        );
        this.commLogs = cloneData;
    }

    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    checkFilterChanges() {
        if (
            this.retrievedStartDate != this.startDate ||
            this.retrievedEndDate != this.endDate
        )
            this.loaded = false;
        else if (this.commLogs) this.loaded = true;
    }

    getChannels() {
        getChannels()
            .then((channels) => {
                if (channels !== null) {
                    this.channels = channels;
                    this.channels.unshift({
                        label: "All",
                        value: ""
                    });
                } else this.showError("Error", "Empty channels.");
            })
            .catch((error) => {
                this.showError("Error retriving channels", error.body.message);
            });
    }

    getStatuses() {
        getStatuses()
            .then((statuses) => {
                if (statuses !== null) {
                    this.statuses = statuses;
                    this.statuses.unshift({
                        label: "All",
                        value: ""
                    });
                } else
                    this.showError("Error", "Empty deliverability statuses.");
            })
            .catch((error) => {
                this.showError(
                    "Error retriving deliverability statuses",
                    error.body.message
                );
            });
    }

    filterLogs() {
        this.cleanFilters =
            this.filterSubject || this.selectedChannel || this.selectedStatus;
        this.commLogs = this.retrievedLogs.filter(
            (x) =>
                x.subject
                    .toLowerCase()
                    .includes(this.filterSubject.toLowerCase()) &&
                (!this.selectedChannel ||
                    x.channelId == this.selectedChannel) &&
                (!this.selectedStatus || x.statusId == this.selectedStatus)
        );

        this.sortLogs();
    }

    previewCommLog(log) {
        this.loading = true;

        getTemplateDetails({
            log: log
        })
            .then((template) => {
                if (template !== null) {
                    OptimoveCommLogPreview.open({
                        subject: template.name,
                        body: template.content
                    }).then((result) => {
                        console.log(result);
                    });
                } else {
                    this.showError("Error", "Unable to retrieve template.");
                }

                this.loading = false;
            })
            .catch((error) => {
                this.loading = false;

                this.showError("Error retriving template", error.body.message);
            });
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
