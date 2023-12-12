import { LightningElement, api,wire } from 'lwc';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';
import ACCOUNT_HOYAID from '@salesforce/schema/Account.Hoya_Account_ID__c';
const FIELDS = [
    ACCOUNT_HOYAID
];  

export default class TabStatisticsProductMixPdf extends LightningElement {
    @api receivedId;
    statPdf;
    accHoyaId;
    statConsoPdf
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    
    
    @wire(getRecord, { recordId: '$receivedId', fields: [ACCOUNT_HOYAID] })
    record({ error, data }) {
        if (data) {
            this.accHoyaId = data.fields.Hoya_Account_ID__c.value;
            console.log('>>>>this.accHoyaId1',this.accHoyaId);
            this.statPdf = 'http://ec2-34-252-248-24.eu-west-1.compute.amazonaws.com/SfdcSynchroWeb/DocumentWebService?entity=seikostat&id='+this.receivedId+'&name='+this.accHoyaId+'.pdf';
            this.statConsoPdf ='http://ec2-34-252-248-24.eu-west-1.compute.amazonaws.com/SfdcSynchroWeb/DocumentWebService?entity=seikostat&id='+this.receivedId+'&name='+this.accHoyaId+'conso.pdf';
        }
    }
    connectedCallback() {
        console.log('child connected call-' + this.receivedId);
        console.log('>>>>this.accHoyaId2',this.accHoyaId);
        //this.statPdf = 'http://ec2-34-252-248-24.eu-west-1.compute.amazonaws.com/SfdcSynchroWeb/DocumentWebService?entity=seikostat&id='+this.receivedId+'&name='+this.accHoyaId+'.pdf';
        //this.statConsoPdf ='http://ec2-34-252-248-24.eu-west-1.compute.amazonaws.com/SfdcSynchroWeb/DocumentWebService?entity=seikostat&id='+this.receivedId+'&name='+this.accHoyaId+'conso.pdf';

    }
   
}