import { LightningElement, api } from 'lwc';

//labels
import potentialTab from '@salesforce/label/c.PotentialTab';
import netSales from '@salesforce/label/c.Net_Sales';
import grossSales from '@salesforce/label/c.Gross_Sales';
import returns from '@salesforce/label/c.Returns';
import shipments from '@salesforce/label/c.Shipments';
import pdf from '@salesforce/label/c.Product_Mix_PDF';


export default class TabStatistics extends LightningElement {
    @api recordId;

    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        potentialTab,netSales,grossSales,returns,shipments,pdf
    }
    connectedCallback() {
        console.log('parent connected callback call' + this.recordId);
    }

    renderedCallback(){
    }
}