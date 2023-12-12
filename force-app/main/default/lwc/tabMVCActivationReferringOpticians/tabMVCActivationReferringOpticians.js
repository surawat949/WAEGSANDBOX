import { LightningElement, api ,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';

//labels
import ReferringOpticians from '@salesforce/label/c.tabContactActivationRefOpts';
import Brand from '@salesforce/label/c.AccountBrand';
import Account from '@salesforce/label/c.AccountName';
import ShopStreet from '@salesforce/label/c.ShopStreet';
import PostalCode from '@salesforce/label/c.PostalCode';
import ShopCity from '@salesforce/label/c.ShopCity';
import ShopPhone from '@salesforce/label/c.ShopPhone';
import Add from '@salesforce/label/c.AddRelation';
import pdfList from '@salesforce/label/c.SFDC_V_2_tabMVCContact_ReferringOptician_PDFList';

//Apex
import getRefOptsList from '@salesforce/apex/TabMVCActivationController.getRefferingOptsLst';

import lWCModal from 'c/tabMVCActivationPdfList';

export default class TabMVCActivationReferringOpticians extends LightningElement {

    @api receivedId;
    Columns;
    wiredResults;
    data;
    isDataExists = false;
    isLoading = true;
    custLabel = {
        ReferringOpticians,
        Add,
        pdfList
    }
    constructor() {
        super();
        // passed parameters are not yet received here
    }    
    async showPopUp() {
        this.template.querySelector('c-tab-contact-create-reffering-optician-modal').displayModal();
    }

    Columns = [
        {label: Brand, fieldName: 'Brand', type: 'text'},
        {label: Account, fieldName: 'AccountId', type: 'url', typeAttributes: {label:{fieldName: 'AccountName'}, target:'_top'}},
        {label: ShopStreet, fieldName: 'ShopStreet', type: 'text'},
        {label: PostalCode, fieldName: 'PostalCode', type: 'text'},
        {label: ShopCity, fieldName: 'City', type: 'text'},
        {label: ShopPhone, fieldName: 'ShopPhone', type: 'text'}
    ];
    @wire(getRefOptsList, {contactId: '$receivedId',isMiyoSmart : false})
    RefOpts(result){
        this.wiredResults = result;
        if(result.data){
            this.data = JSON.parse(JSON.stringify(result.data));
            this.isLoading = false;
            if(this.data.length > 0 )
             this.isDataExists = true;
            this.data.forEach(res=>{
                res.Brand = res.brand;
                res.AccountId = '/' + res.accountId;
                res.AccountName = res.accountName;
                res.ShopStreet = res.shopStreet;
                res.PostalCode = res.postalCode;
                res.City = res.shopCity;
                res.ShopPhone = res.shopPhone;
            });
            this.error = undefined;
        }else if(result.error){
            this.error = result.error;
            this.showToast('Error', 'Error', result.error);
            this.data = undefined;
        }
    }
    connectedCallback() {
        //console.log('child connected call-' + this.receivedId);
    }
    async showSuccessToast() {
        const evt = new ShowToastEvent({
          title: "New Referring Optician added",
          message: "Success",
          variant: "success"
        });
        this.dispatchEvent(evt);
    }

    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }

    async performRefresh() {
        await refreshApex(this.wiredResults);  
    }

    async openModal() {
        const result = await lWCModal.open({
            size: 'medium', //small, medium, or large default :medium
            receivedId : this.receivedId
        });
        //console.log(result);
    }
      
}