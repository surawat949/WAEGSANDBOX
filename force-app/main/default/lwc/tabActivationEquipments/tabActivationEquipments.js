import { LightningElement, api } from 'lwc';

export default class TabActivationEquipments extends LightningElement {
    @api receivedId;
    _brand;
    isHoyaAcc = false;

    @api
    set brand (value) {
        this._brand = value;
        if (this._brand === 'HOYA') {
            this.isHoyaAcc = true;
        } else {
            this.isHoyaAcc = false;
        }
    }
    get brand() {
        return this._brand;
    }
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        console.log('child connected call-' + this.receivedId);
    }
}