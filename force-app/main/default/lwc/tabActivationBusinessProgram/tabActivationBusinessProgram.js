import { LightningElement, api } from 'lwc';

export default class TabActivationBusinessProgram extends LightningElement {
    @api receivedId;
    @api seikoData;
    @api brand;
    @api channel;
    @api loyaltyPoints;
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        console.log('child connected call-' + this.receivedId);
    }
}