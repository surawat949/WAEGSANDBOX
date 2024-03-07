import { LightningElement, api,wire } from 'lwc';

import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

import getRelatedClinicsByContactId from '@salesforce/apex/tabMVCContactController.getRelatedClinicsByContactId';

import other_Related_Clinics from '@salesforce/label/c.Other_Related_Clinics';
import Account from '@salesforce/label/c.Account';
import Clinic_Name from '@salesforce/label/c.Clinic_Name';
import Shipping_City from '@salesforce/label/c.Shipping_City';
import Preferred_Place_for_Visit from '@salesforce/label/c.Preferred_Place_for_Visit';
import Contact_Role from '@salesforce/label/c.Contact_Role';
import Activity_Phone from '@salesforce/label/c.Activity_Phone';
import Working_Status from '@salesforce/label/c.Working_Status';
import Preferred_Contact_day_time from '@salesforce/label/c.Preferred_Contact_day_time';
import Relation_Id from '@salesforce/label/c.Relation_Id';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';


import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class TabMVCContactWorkingPlaces extends NavigationMixin(LightningElement) {
    
    @api receivedId;
    isDataExists;
    data;
    AccountIdData;
    error;
    error2;
    isLoading = true;
    Account_Id;
    AccountTemplateCopy;
    lables={
        other_Related_Clinics
    }
    subscription = {};
    CHANNEL_NAME = '/event/Refresh_Related_List_ACR__e';

    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        this.getRelatedClinic();
        subscribe(this.CHANNEL_NAME, -1, this.refreshList).then(response => {
            this.subscription = response;
        });
        onError(error => {
            this.showToast('Error',this.error,'error');
        });
    }
    refreshList = ()=> {
        this.getRelatedClinic();
    }

    columns =  [
        {label: Account, fieldName: 'AccountId', typeAttributes: {
        label: { fieldName: 'AccountName' }}, 
        type: 'url',target: 'blank',wrapText: true },
        {label: Clinic_Name, fieldName: 'ClinicName', type: 'text',wrapText: true },
        {label: Preferred_Place_for_Visit, fieldName: 'PreferredPlace', 
        type: 'boolean',wrapText: true,cellAttributes: { alignment: 'center' }},
        {label: Shipping_City, fieldName: 'City', type: 'text',wrapText: true },
        {label: Contact_Role, fieldName: 'ContactRole', type: 'text',wrapText: true },
        {label: Activity_Phone, fieldName: 'ActivityPhone', type: 'text',wrapText: true },
        {label: Preferred_Contact_day_time, fieldName: 'PreferredDay', type: 'text',wrapText: true },
        {label: Working_Status, fieldName: 'WorkingStatus', type: 'text',wrapText: true },
        {label: Relation_Id, fieldName: 'RelationName', typeAttributes: {
            label: { fieldName: 'Id' }
          }, type: 'url',target: 'blank',wrapText: true }
        ]

        getRelatedClinic(){
            getRelatedClinicsByContactId({contactId:this.receivedId}).then(result=>{
                if(result){
                    this.isLoading = false;
                    this.data = JSON.parse(JSON.stringify(result));
                    if(this.data.length > 0){
                        this.isDataExists = true;
                        this.data.forEach(row=>{
                            row.Brand= row.Account.Brand__c,
                            row.AccountId= '/'+row.Account.Id,
                            row.AccountName= row.Account.Name,
                            row.Street= row.Account.ShippingStreet,
                            row.PostalCode = row.Account.ShippingPostalCode,
                            row.City= row.Account.ShippingCity,
                            row.SeikoNetwork= row.Account.Seiko_Network__c,
                            row.recordId=  row.Id,
                            row.ClinicName= row.Account.Clinic_Name__c,
                            row.PreferredPlace= row.Preferred_place_for_visit__c,
                            row.ContactRole= row.Contact_role__c,
                            row.ActivityPhone= row.Activity_Phone__c,
                            row.PreferredDay= row.Preferred_contact_day_time__c,
                            row.WorkingStatus= row.Working_Status__c,
                            row.Id= row.Id,
                            row.RelationName= '/'+row.Id
                        });
                    }
                }
                }).catch(error=>{
                this.error = error.body.message;
                this.isLoading = false;
                this.showToast('Error',this.error,'error');
            })
        }


    showToast(title,message,variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    navigateToContactRelationship(event){
        this.navigateToNewPage('AccountContactRelation');
    }

    navigateToNewPage(objectName){
        const defaultValue = encodeDefaultFieldValues({
            ContactId : this.receivedId
        });
		
        this[NavigationMixin.Navigate]({
            type : 'standard__objectPage',
            attributes : {
                objectApiName : objectName,
                actionName : 'new'
            },
            state: {
                defaultFieldValues: defaultValue,
                useRecordTypeCheck : 1,
                navigationLocation: 'RELATED_LIST'  //to avoid prevention of moving to newly created record
            }
        });
    }
    disconnectedCallback() {
        unsubscribe(this.subscription, () => {
        });   
    } 
  

}