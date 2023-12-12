import { LightningElement, api, wire } from 'lwc';

//Apex
//import getContactList from '@salesforce/apex/TabActivationController.getContactList';
import getMainMyopiaControlField from '@salesforce/apex/TabActivationMPMiyosmart.getMainMyopiaDefault';

export default class TabActivationMedicalProgram extends LightningElement {
    @api receivedId;

    MainMyopiaControl;
   
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        console.log('child connected call-' + this.receivedId);
    }

    @wire(getMainMyopiaControlField, {recordId : '$receivedId'})
    getMyopiaControl({error, data}){
        if(error){
            console.log('Error '+error);
        }else if(data){
            this.MainMyopiaControl = data;
        }
    }
  
}