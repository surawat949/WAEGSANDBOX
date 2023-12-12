import { api, LightningElement } from 'lwc';

//labels
import addressTab from '@salesforce/label/c.Address';
import membershipsTab from '@salesforce/label/c.Memberships';


export default class TabAccount extends LightningElement {
    @api recordId;

    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        addressTab,
        membershipsTab
    }

    connectedCallback() {
        console.log('parent connected callback call' + this.recordId);
    }

    renderedCallback(){
    }
}