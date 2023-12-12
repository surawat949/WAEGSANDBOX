import { LightningElement, api } from 'lwc';

//labels
import potentialTab from '@salesforce/label/c.PotentialTab';

export default class TabStatistics extends LightningElement {
    @api recordId;

    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        potentialTab
    }
    connectedCallback() {
        console.log('parent connected callback call' + this.recordId);
    }

    renderedCallback(){
    }
}