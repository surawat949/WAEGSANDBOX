import { api, LightningElement, wire } from 'lwc';

import { getRecord } from 'lightning/uiRecordApi';
import ACCOUNT_BRAND from '@salesforce/schema/Account.Brand__c';
import ACCOUNT_CHANNEL from '@salesforce/schema/Account.Channel__c';
import TOTAL_LOYALTY_POINTS from '@salesforce/schema/Account.Total_Loyalty_Points__c'; 

//labels
import businessProgramTab from '@salesforce/label/c.Business_Program';

// apex
import getSeikoData from '@salesforce/apex/TabActivationController.getSeikoData';

export default class TabActivation extends LightningElement {
    @api recordId;
    seikoData;
    brand;
    channel;
    loyaltyPoints; // to be sent to Loyalty Points tab

    @wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_BRAND, ACCOUNT_CHANNEL, TOTAL_LOYALTY_POINTS] })
    record({ error, data }) {
        if (data) {
            this.brand = data.fields.Brand__c.value;
            this.channel = data.fields.Channel__c.value;
            this.loyaltyPoints = data.fields.Total_Loyalty_Points__c.value;
        }
    }

    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        businessProgramTab
    }
    connectedCallback() {
        console.log('parent connected callback call' + this.recordId);
        getSeikoData({accountId : this.recordId})
        .then(response => {
            this.seikoData = response.Id;
            console.log(this.seikoData);
        })
        .catch(error => {
            console.log(error);
        })
    }

    renderedCallback(){
    }
}