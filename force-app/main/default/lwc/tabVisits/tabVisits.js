import { LightningElement, api } from 'lwc';

//labels
import tacticomTab from '@salesforce/label/c.AccountVisitTabTacticom';

export default class TabVisits extends LightningElement {
    @api recordId;

    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        tacticomTab
    }
    connectedCallback() {
        console.log('parent connected callback call' + this.recordId);
    }

    renderedCallback(){
    }
}