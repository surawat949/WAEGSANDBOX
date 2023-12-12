/**
 * @filename : tabAccountAddress.html
 * @description : tabAccountAddress.html to support Account Address in SFDC V.2.0 Project
 * @Author : Surawat Sakulmontreechai
 * @Group : Account Tab
 * @CreatedBy : Surawat Sakulmontreechai
 * @CreatedDate : 2023-06-06
 * @LastModifiedBy : Surawat Sakulmontreechai
 * @LastModifiedDate : 2023-06-20
 * @Email : surawat.sakulmontreechai@hoya.com
 * @Noted & description :   For the new tab in Account Address need to create more fields into Account object.
 *                          Unfortunately, we have no more space for new custom fields in Account object.
 *                          Then, I need to remove some unnecessary field in Account object - WAEG first in the meantime.
 *                          Let's discuss on this again for new fields created or let recycle some field existing when deploying to prod.
 */

import { LightningElement, api, wire, track } from 'lwc';
import { RefreshEvent } from 'lightning/refresh';
import Account_Retail_Name from '@salesforce/schema/Account.Retail_Name__c';      //new field - need create on Account object
import Account_Phone from '@salesforce/schema/Account.Phone';                       
//import Account_Type from '@salesforce/schema/Account.Type';
import Account_Fax from '@salesforce/schema/Account.Fax';
//import Account_Channel from '@salesforce/schema/Account.Channel__c';
//import Account_Local_Classification from '@salesforce/schema/Account.Pre_Boarding_Status__c';
//import Account_Status from '@salesforce/schema/Account.Account_Status__c';  
import Account_Email_Survey_Email_Address from '@salesforce/schema/Account.Surveys_Email__c';    //new field - need create on Account object
import Account_Email_Confidentail_Email_Address from '@salesforce/schema/Account.Confidential_Email_Address__c';    //new field - need create on Account object
import Account_Email_Marketing_Email_Address from '@salesforce/schema/Account.email__c';  //new field - need create on Account object
//import Account_Email_Track_and_Trace_Email_Addreess from '@salesforce/schema/Account.Track_and_Trace_Email_Address__c'; //new field - need create on Account object
import Account_Brand from '@salesforce/schema/Account.Brand__c';
import Account_Mobile_Phone from '@salesforce/schema/Account.Account_Mobile_Phone__c';

/**=== TO IMPORT FOR NEW FIELDS FROM ACCOUNT OBJECT FROM Shop__ Address instead using fro new fields =============== **/
import Account_Shop_Street from '@salesforce/schema/Account.Shop_Street__c';
import Account_Shop_City from '@salesforce/schema/Account.Shop_City__c';
import Account_Shop_State from '@salesforce/schema/Account.Shop_State__c';
import Account_Shop_Postal_Code from '@salesforce/schema/Account.Shop_Postal_Code__c';
import Account_Shop_Country from '@salesforce/schema/Account.Shop_Country__c';
//import Account_Legacy_Number from '@salesforce/schema/Account.Legacy_Account_Number__c';
import Account_Shop_Email_Address from '@salesforce/schema/Account.Shop_email_address__c';
import Account_Shop_Website from '@salesforce/schema/Account.Website';
import Account_Legacy_Number from '@salesforce/schema/Account.Legacy_Account_Number__c';
//import Account_HVC_Inter_Channel from '@salesforce/schema/Account.CHCUSTCLASSIFICATIONID__c';
//import Account_Status from '@salesforce/schema/Account.Account_Status__c';
//import Account_LocalClassification1 from '@salesforce/schema/Account.Local_Classification_1__c';
//import Account_LocalClassification2 from '@salesforce/schema/Account.Local_Segm__c';
import Account_obj from '@salesforce/schema/Account';
/**==================== END =============================================== **/

import label_Address from '@salesforce/label/c.tabAccMainAddress_Address';
import label_Contact from '@salesforce/label/c.tabAccMainAddress_Contacts';
import label_SpecificEmail from '@salesforce/label/c.tabAccMainAddress_SpecificEmail';
import label_demand from '@salesforce/label/c.tabAccButtonDemand';
import label_copyemail from '@salesforce/label/c.tabAccButtonCopyEmail';
import label_new from '@salesforce/label/c.NewButtonRelatedList';
import label_viewall from '@salesforce/label/c.ViewAllRelatedList';
import label_ContactName from '@salesforce/label/c.tabAccContactName';
import label_ContRecType from '@salesforce/label/c.tabAccContactRecType';
import label_salutation from '@salesforce/label/c.tabAccContactSalutation';
import label_title from '@salesforce/label/c.tabAccContactTitle';
import label_email from '@salesforce/label/c.tabAccContactEmail';
import label_phone from '@salesforce/label/c.tabAccContactPhone';

import getRelatedContactAccountRec from '@salesforce/apex/tabAccountAddressLWCController.getContactsRelatedAccount';
import updateEmailToAll from '@salesforce/apex/tabAccountAddressLWCController.UpdateAccountEmail';
import getConCount from '@salesforce/apex/tabAccountAddressLWCController.getConCount';
import getIndicators from '@salesforce/apex/tabAIIndicatorsController.getAIIndicators';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import TabAccountAddressToCreateNewTaskModal from 'c/tabAccountAddressToCreateNewTaskModal';
import TabAccountContactDeployment from 'c/tabAccountContactDeployment';
import AI_Indicators from '@salesforce/resourceUrl/SFDC_V2_AI_Indicators';
/**======================================================================== **/

export default class TabAccountAddress extends NavigationMixin(LightningElement) {
    @track ContactRecord;
    @track isLoading = false;
    @api receivedId;
    contactData;
    contactCount;
    labelContactName = label_ContactName;
    labelContactRecType = label_ContRecType;
    labelContactSalutation = label_salutation;
    labelContactTitle = label_title;
    labelContactEmail = label_email;
    labelContactPhone = label_phone;

    salesIndicator;
    contactIndicator;
    deliveryIndicator;
    returnsIndicator;
    paymentsIndicator;
    satisfactionIndicator;

    // meanings
    contactMeaning;
    returnsFlagMeaning;
    salesFlagMeaning;
    paymentsFlagMeaning;
    satisfactionFlagMeaning;
    deliveriesFlagMeaning;


    @track columns = [
        {
            label: this.labelContactName,
            fieldName: 'conLink',
            type: 'url',
                typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
            sortable: true

        },
        {
            label: this.labelContactRecType,
            fieldName: 'Contact_Record_Type__c',
            type: 'text',
            sortable: true
        },
        {
            label: this.labelContactSalutation,
            fieldName: 'Salutation',
            type: 'text',
            sortable: true 
        },
        {
            label: this.labelContactTitle,
            fieldName: 'Title',
            type: 'text',
            sortable: true
        },
        {
            label: this.labelContactEmail,
            fieldName: 'Email',
            type: 'email',
            sortable: true
        },
        {
            label: this.labelContactPhone,
            fieldName: 'Phone',
            type: 'phone',
            sortable: true
        }
    ];
    objectApiName = Account_obj;
    Survey_Eamil_Fields = [Account_Email_Survey_Email_Address,Account_Email_Confidentail_Email_Address,Account_Email_Marketing_Email_Address];
    field1 = [Account_Retail_Name, Account_Phone];
    field2 = [Account_Shop_Street, Account_Mobile_Phone];
    field3 = [Account_Shop_Postal_Code, Account_Fax];
    field4 = [Account_Shop_City, Account_Shop_Email_Address];
    field5 = [Account_Shop_State, Account_Shop_Website];
    field6 = [Account_Shop_Country, Account_Legacy_Number];

    @wire(getRelatedContactAccountRec, {receivedId:'$receivedId'})
        contactRec({error, data}){
            if(data){
                data = JSON.parse(JSON.stringify(data));
                data.forEach(res=>{
                    res.conLink = '/' + res.Id;
                });
                this.ContactRecord = data;
            }else if (error){
                console.log('An error was occurred : ', error);
            }
        }
    
    @wire(getConCount, {receivedId: '$receivedId'})
        conCount({error, data}){
            if(data){
                data = JSON.parse(JSON.stringify(data));
                let allContact = data;
                this.contactData = (allContact.length<=5) ? [...allContact] : [...allContact].splice(0,6);
                if(allContact.length > 5){
                    this.contactCount = '5+';
                }else{
                    this.contactCount = allContact.length;
                }
            }else if(error){
                console.log('XXX An error was occurred ==>'+JSON.stringify(error));
            }
        }
    
    @wire(getIndicators, {receivedId: '$receivedId',tabName:'Address'})  getIndicators ({error, data}) {
        if(data){
            this.salesIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.salesFlag);
            this.contactIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.contactFlag);
            this.deliveryIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.deliveriesFlag);
            this.returnsIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.returnsFlag);
            this.paymentsIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.paymentsFlag);
            this.satisfactionIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.satisfactionFlag);
            //meaning
            this.contactMeaning = data.contactMeaning;
            this.salesFlagMeaning = data.salesFlagMeaning;
            this.returnsFlagMeaning = data.returnsFlagMeaning;
            this.paymentsFlagMeaning= data.paymentsFlagMeaning;
            this.satisfactionFlagMeaning = data.satisfactionFlagMeaning;
            this.deliveriesFlagMeaning= data.deliveriesFlagMeaning;

        }else if(error){
            console.log('XXX An error was occurred ==>'+JSON.stringify(error));
        }
    }
    getIndicatorImage(indicator){
        if(indicator == 'GREY')
            return 'GreyLight.png';
        else if(indicator == 'GREYALERT')
            return 'GreyLightAlert.png';
        else if(indicator == 'RED')
            return 'RedLight.png';
        else if(indicator == 'REDALERT')
            return 'RedLightAlert.png';
        else if(indicator == 'GREEN')
            return 'GreenLight.png';
        else if(indicator == 'GREENALERT')
            return 'GreenLightAlert.png';

    }
    handleSuccess(event){
        const evt = new ShowToastEvent({
            title : 'Account Update',
            message : 'Record Id '+event.detail.id+' Updated',
            variant : 'success'
        });
        this.dispatchEvent(evt);
        this.dispatchEvent(new RefreshEvent());
    }
    navigateToRelatedList(){
        this[ NavigationMixin.GenerateUrl ]({
            type : 'standard__recordRelationshipPage',
            attributes : {
                recordId : this.receivedId,
                objectApiName : 'Account',
                relationshipApiName : 'Contacts',
                actionName : 'view'
            }
        }).then(url => {
            window.open(url, '_blank');
        });
    }
    neviageToNewRecordPage(){
        const defaultValues = encodeDefaultFieldValues({
           AccountId : this.receivedId
        });

        console.log(defaultValues);

        this[ NavigationMixin.Navigate]({
            type : 'standard__objectPage',
            attributes : {
                objectApiName : 'Contact',
                actionName : 'new'
            },
            state: {
                defaultFieldValues: defaultValues,
                useRecordTypeCheck : 1
            }
        });
    }
    handleClick(){
        this.handleIsLoading(true);
        updateEmailToAll({ receivedId: this.receivedId }).then(result => {
            this.updateRecordView();
            this.showToast('Success', result,'Success', 'dismissable');
        }).catch(error => {
            this.showToast('Error updating or refreshing records', error.body.message, 'Error', 'dismissable');
        }).finally(()=>{
            this.handleIsLoading(false);
        });
    }
    showToast(title, message, variant, mode){
        const event = new ShowToastEvent({
            title : title,
            message : message,
            variant : variant,
            mode : mode
        });
        this.dispatchEvent(event);
    }
    //show hide spinner
    handleIsLoading(isLoading){
        this.isLoading = isLoading;
    }
    updateRecordView(){
        setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
        },1000);
        this.dispatchEvent(new RefreshEvent());
    }
    async showPopup() {
        const recordId = await TabAccountAddressToCreateNewTaskModal.open({
          size: 'small',
          receivedId: this.receivedId
        });
    
        if (recordId) {
          await this.showSuccessToast(this.receivedId);
        }
    }
    async showContactPopup(){
        const recordId = await TabAccountContactDeployment.open({
            size: 'small',
            receivedId: this.receivedId
        });
        if (recordId) {
            await this.showSuccessToast(this.receivedId);
        }
    }
    async showSuccessToast(recordId) {
        const evt = new ShowToastEvent({
          title: "New Account Created",
          message: "Record ID: " + this.receivedId,
          variant: "success"
        });
        this.dispatchEvent(evt);
    }

    label = {label_Address, 
            label_Contact, label_SpecificEmail, 
            label_demand, label_copyemail, 
            label_new, label_viewall};
}