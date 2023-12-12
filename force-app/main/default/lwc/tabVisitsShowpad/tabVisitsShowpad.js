import { LightningElement, api } from 'lwc';

export default class TabVisitsShowpad extends LightningElement {
    @api receivedId;
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        console.log('child connected call-' + this.receivedId);
    }
}