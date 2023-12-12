import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import MiyosmartAuthorizedDealers from '@salesforce/label/c.SFDC_V_2_MVA_Activation_Prescriber_MiyosmartAuthorizedDealers';
import Myo_Smart_AuthorizeDealer__c from '@salesforce/schema/Account.Myo_Smart_AuthorizeDealer__c'; 
import Myo_Smart_TrainingComplete__c from '@salesforce/schema/Account.Myo_Smart_TrainingComplete__c'; 
import Myo_Kids_Corner__c from '@salesforce/schema/Account.Myo_Kids_Corner__c'; 
import Myo_Main_Comp_Myopia_Control__c from '@salesforce/schema/Account.Myo_Main_Comp_Myopia_Control__c'; 
import Myo_NotesComments__c from '@salesforce/schema/Account.Myo_NotesComments__c';
import Myo_MiopiaControl from '@salesforce/schema/Account.Myo_Main_Comp_Myopia_Control__c';

import Monthly_Children_Patients__c from '@salesforce/schema/Last_Sales_Statistics__c.Monthly_Children_Patients__c';
import Monthly_Myopia_Control_Pairs_Sold__c from '@salesforce/schema/Last_Sales_Statistics__c.Monthly_Myopia_Control_Pairs_Sold__c'; 
import Miyosmart_vs_Myopia_Control__c from '@salesforce/schema/Last_Sales_Statistics__c.Miyosmart_vs_Myopia_Control__c'; 
import Miyosmart_vs_Children_Patients_L3Mo__c from '@salesforce/schema/Last_Sales_Statistics__c.Miyosmart_vs_Children_Patients_L3Mo__c'; 
import IsMiyoSmartTrainingCompleted from '@salesforce/label/c.MiyoSmartTrainingComplete';
import LastMiyoSmartTrainingDate from '@salesforce/label/c.LastMiyoSmartDate';

//apex
import getLastSalesStats from '@salesforce/apex/TabActivationMPMiyosmart.getLastSalesStats';
import getLastTrainingDate from '@salesforce/apex/TabActivationMPMiyosmart.getLastTrainingDate';
import UpdateMyopiaControl from '@salesforce/apex/TabActivationMPMiyosmart.UpdateMainMyopiaField';
import getMainMyopiaControlField from '@salesforce/apex/TabActivationMPMiyosmart.getMainMyopiaDefault';
import { refreshApex } from '@salesforce/apex';

import { RefreshEvent } from 'lightning/refresh';

export default class TabActivationMedicalProgramMiyosmart extends LightningElement {
    @api receivedId;
    @api defaultRecordValue;
    MainMyopiaControl;

    salesStatsId = '';
    ObjectApiNameAccount = 'Account';
    ObjectApiName_Last_Sales = 'Last_Sales_Statistics__c';
    isViewMode = 'readonly';
    LastTraningDate;
    isTrainingComplete;
    Myofield;
    record;
    error;

    PotentialFields = [Myo_Smart_AuthorizeDealer__c];

    Last_Sales_Statistics_Fields=[Monthly_Children_Patients__c, Monthly_Myopia_Control_Pairs_Sold__c];
    Kids_corner = [Myo_Kids_Corner__c];
    formulaFields = [Miyosmart_vs_Myopia_Control__c, Miyosmart_vs_Children_Patients_L3Mo__c];
    childrenPatientFields = [Myo_Main_Comp_Myopia_Control__c];
    notes_comments = [Myo_NotesComments__c];
    MiopiaControl = [Myo_MiopiaControl];

    label={
            MiyosmartAuthorizedDealers,
            IsMiyoSmartTrainingCompleted,LastMiyoSmartTrainingDate
    }
  
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }

    connectedCallback() {
        //console.log('child connected call-' + this.receivedId);
        this.getLastSalesStats();
        getLastTrainingDate({accountId : this.receivedId})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            console.log('>>>>response',response);
            this.LastTraningDate = response;
            console.log('>>>>LastTraningDate',this.LastTraningDate);
            if(this.LastTraningDate != null && this.LastTraningDate != undefined && this.LastTraningDate !='') 
                this.isTrainingComplete = true;
            else{this.isTrainingComplete = false;}
                
                console.log('>>>>isTrainingComplete',this.isTrainingComplete);
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })

    }

    renderedCallback(){
        refreshApex(this.getMyopia);
        this.dispatchEvent(new RefreshEvent());
        //this.MyopiaControlField = this.Myofield;
    }

    @wire(getMainMyopiaControlField, {recordId : '$receivedId'})
    getMyopia({error, data}){
        if(error){
            this.showToast('Error', error, 'error');
        }else if(data){
            this.MainMyopiaControl = JSON.parse(JSON.stringify(data));
        }
    }
    
    handleLookupMainCompetitorChange(event){
        if(event.detail.selectedRecord != undefined){
            this.MainMyopiaControl = event.detail.selectedRecord.Value;
            //console.log('Main Myopia Control =>'+this.MainMyopiaControl);
        }else{
            this.MainMyopiaControl = undefined;
            
        }
    }

    handleUpdateMainMyopiaControl(){
        UpdateMyopiaControl({
            recordId : this.receivedId,
            MainMyopiaName : this.MainMyopiaControl
        }).then(result=>{
            this.showToast('Success', 'Success updated Main Competitor Myopia Control '+JSON.stringify(this.MainMyopiaControl), 'success');
            this.handleGobackMiopia();
            this.updateRecordView();
        }).catch(error=>{
            this.showToast('Error', 'Error during update the record.', 'error');
        });
    }

    handleEditMiopia(){
        //this.MyopiaControlField = this.Myofield;
        this.template.querySelector('div.stepOne').classList.add('slds-hide');
        this.template.querySelector('div.stepTwo').classList.remove('slds-hide');
    }

    handleGobackMiopia(){
        this.template.querySelector('div.stepOne').classList.remove('slds-hide');
        this.template.querySelector('div.stepTwo').classList.add('slds-hide');
    }

    getLastSalesStats() {
        getLastSalesStats({receivedId: this.receivedId})
            .then(data => {
                if(data){
                    this.salesStatsId = data;
                    this.isViewMode='view';
                }
                else{
                    this.isViewMode='readonly';
                }
            });
    }

    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        });
        this.dispatchEvent(event);
    }

    updateRecordView(){
        setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
            this.showLoading = false;
            this.isRender = true;            
        },30000);
        this.dispatchEvent(new RefreshEvent());
    }
  
}