/**
 * @filename : tabAccountContactDeployement
 * @description : tabAccountContactDeployment to support Account Address in SFDC V.2.0 Project
 * @Author : Surawat Sakulmontreechai
 * @Group : Account Tab
 * @CreatedBy : Surawat Sakulmontreechai
 * @CreatedDate : 2023-06-21
 * @LastModifiedBy : Surawat Sakulmontreechai
 * @LastModifiedDate : 2023-06-28
 * @Email : surawat.sakulmontreechai@hoya.com
 * @NotedAndDescription : before create a new contact must have some vefication, before create new
 *                          data in system (Contact)
 */

import { LightningElement, api, track, wire } from 'lwc';
//import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getContactRecordType from '@salesforce/apex/tabAccountAddressLWCController.getContactRecordTypeDescribe';
//import getContactRecordTypeNotIn from '@salesforce/apex/tabAccountAddressLWCController.getContactRecordTypeDescribeNotIn';
import getAccTemplate from '@salesforce/apex/tabAccountAddressLWCController.getAccountTemplateForAccountId';
import getPicklistValuesList from '@salesforce/apex/tabAccountAddressLWCController.getPicklistLanguage';
import createContact from '@salesforce/apex/tabAccountAddressLWCController.createNewContact';
import ShopOwnerRecordType from '@salesforce/apex/tabAccountAddressLWCController.getContactRecordTypeShopOwner';
import EmployeeRecordType from '@salesforce/apex/tabAccountAddressLWCController.getContactRecordTypeEmployee';
import OpthalRecordType from '@salesforce/apex/tabAccountAddressLWCController.getContactRecordTypeOpthal';
import getOtherRecType from '@salesforce/apex/tabAccountAddressLWCController.getContactRecordTypeRest';
import getEducationValues from '@salesforce/apex/tabAccountAddressLWCController.getpicklistEducationValues';
import getEducationValuesRest from '@salesforce/apex/tabAccountAddressLWCController.getpicklistEducationValuesRest';

import label_ContactName from '@salesforce/label/c.tabContactModalName';
import label_ContactProfile from '@salesforce/label/c.tabContactModalProfile';
import label_ContactCommunication from '@salesforce/label/c.tabContactModalCommunication';
import label_ContactPortal from '@salesforce/label/c.tabContactModalPortal';
import label_ContactMr from '@salesforce/label/c.tabLabelMr';
import label_ContactMrs from '@salesforce/label/c.tabLabelMrs';
import label_ContactDr from '@salesforce/label/c.tabLabelDr';
import label_ContactProf from '@salesforce/label/c.tabLabelProf';
import label_message1 from '@salesforce/label/c.tabContactModalMessage1';
import label_step1 from '@salesforce/label/c.tabContactModalStep1';
import label_othSalut from '@salesforce/label/c.tabContactModalOthSalut';
import label_othSalutPlace from '@salesforce/label/c.tabContactModalOthSalutPlace';
import label_firstname from '@salesforce/label/c.tabContactModalFirstName';
import label_lastname from '@salesforce/label/c.tabContactModalLastName';
import label_title from '@salesforce/label/c.tabContactModalTitle';
import label_next from '@salesforce/label/c.tabLabelNext';
import label_step2 from '@salesforce/label/c.tabContactModalStep2';
import label_message2 from '@salesforce/label/c.tabContactModalMessage2';
import label_othRecType from '@salesforce/label/c.tabContactModalOthRecType';
import label_othRecTypePlace from '@salesforce/label/c.tabContactModalOthRecTypePlace';
import label_role from '@salesforce/label/c.tablabelRole';
import label_education from '@salesforce/label/c.tabContactModalEducation';
import label_othEducation from '@salesforce/label/c.tabContactModalOthEducation';
import label_othEducationPlace from '@salesforce/label/c.tabContactModalOthEducationPlace';
import label_previous from '@salesforce/label/c.labelPrevious';
import label_save from '@salesforce/label/c.tabLabelSave';
import label_step3 from '@salesforce/label/c.tabContactModalStep3';
import label_message3 from '@salesforce/label/c.tabContactModalMessage3';
import label_phone from '@salesforce/label/c.tabContactModalPhone';
import label_mobile from '@salesforce/label/c.tabContactModalMobile';
import label_email from '@salesforce/label/c.tabContactModalEmail';
import label_step4 from '@salesforce/label/c.tabContactModalStep4';
import label_message4 from '@salesforce/label/c.tabContactModalMessage4';
import label_accTemplate from '@salesforce/label/c.tabContactModalAccTemplate';
import label_accTemplatePlace from '@salesforce/label/c.tabContactModalAcctemplatePlace';
import label_language from '@salesforce/label/c.tabContactModalLanguage';
import label_languagePlace from '@salesforce/label/c.tabContactModalLanguagePlace';
import label_sendEmailImm from '@salesforce/label/c.tabContactModalSendEmailImm';

//import getContactRecordId from '@salesforce/apex/tabAccountAddressLWCController.getContactId';
//import CONTACT_SALUTATION from '@salesforce/schema/Contact.Salutation';
//import CONTACT_FIRSTNAME from '@salesforce/schema/Contact.FirstName';
//import CONTACT_LASTNAME from '@salesforce/schema/Contact.LastName';
//import CONTACT_TITLE from '@salesforce/schema/Contact.Title';
//import CONTACT_OBJECT from '@salesforce/schema/Contact';

import LightningModal from 'lightning/modal';

let i = 0;
let j = 0;
let k = 0;
let l = 0;
let m = 0;

export default class TabAccountContactDeployment extends LightningModal {
    @api receivedId;
    errors;
    errors2;
    errors3;
    errors4;
    errors5;
    showSpinner;
    value='';
    accountid = this.receivedId;
    firstname;
    lastname;
    title;
    phone;
    mobilephone;
    email;
    SendInvitationPortal = false;
    //SystemInvitationEmail = false;
    SendImmDiately = false;

    labelContactName = label_ContactName;
    labelContactProfile = label_ContactProfile;
    labelContactCommunication = label_ContactCommunication;
    labelContactPortal = label_ContactPortal;
    labelMr = label_ContactMr;
    labelMrs = label_ContactMrs;
    labelDr = label_ContactDr;
    labelProf = label_ContactProf;
    labelMessage1 = label_message1;
    labelStep1 = label_step1;
    labelOthSalut = label_othSalut;
    labelOthSalutPlace = label_othSalutPlace;
    labelFirstname = label_firstname;
    labelLastname = label_lastname;
    labelTitle = label_title;
    labelNext = label_next;
    labelPrev = label_previous;
    labelSave = label_save;
    labelStep2 = label_step2;
    labelMessage2 = label_message2;
    labelOthRecType = label_othRecType;
    labelOthRecTypePlace = label_othRecTypePlace;
    labelRole = label_role;
    labelEducation = label_education;
    labelOthEducation = label_othEducation;
    labelOthEducationPlace = label_othEducationPlace;
    labelStep3 = label_step3;
    labelMessage3 = label_message3;
    labelPhone = label_phone;
    labelMobile = label_mobile;
    labelEmail = label_email;
    labelstep4 = label_step4;
    labelMessage4 = label_message4;
    labelAccTemplate = label_accTemplate;
    labelAccTemplatePlace = label_accTemplatePlace;
    labelLanguage = label_language;
    labelLanguagePlace = label_languagePlace;
    labelSendEmailImm = label_sendEmailImm;

    @track currentStep = '1';
    @track ContactRTRecordList;
    @track ContactRTNotInRecordList;
    @track AccountTemplateRecordList;
    @track ShopOwnerRecType;
    @track EmployeeRecType;
    @track OpthalRecType;
    @track items = [];
    @track items2 = [];
    @track itmes3 = [];
    @track items4 = [];
    @track items5 = [];
    @track salut_value;
    @track RecordTypeValue;
    @track RecordTypeLabel;
    @track education;
    @track languagepick;
    @track AccountTemplate;
    @track req = false;
    @track isLoading = false;
    @track disabledButton = false;

    @wire(ShopOwnerRecordType) wireShopOwnerRecord({data, error}){
        if(data){
            this.ShopOwnerRecType = data;
            console.log('XXX Get Shop Owner Record Type'+JSON.stringify(this.ShopOwnerRecType));
        }else if(error){
            console.log('XXX Get Shop Owner Record Type ERROR =>'+JSON.stringify(error));
        }
    }

    @wire(EmployeeRecordType) wireEmployeeRecord({data, error}){
        if(data){
            this.EmployeeRecType = data;
            console.log('XXX Get Employee Record Type '+JSON.stringify(this.EmployeeRecType));
        }else if(error){
            console.log('XXX Get Employee Record Type ERROR => '+JSON.stringify(error));
        }
    }

    @wire(OpthalRecordType) wireOpthalRecord({data, error}){
        if(data){
            this.OpthalRecType = data;
            console.log('XXX Get Opthalmologist Record Type '+JSON.stringify(this.OpthalRecType));
        }else if(error){
            console.log('XXX Get Opthalmologist Record Type ERROR => '+JSON.stringify(error));
        }
    }

    @wire(getContactRecordType) wireContactRecordType({data, error}){
        if(data){
            this.ContactRTRecordList=data;
            console.log('XXX Contact Record Type Data == > '+this.ContactRTRecordList);
        }else if(error){
            console.log('XXX An error was occurred');
        }
    }

    @wire(getEducationValuesRest) wireEducationListRest({data, error}){
        if(data){
            for(m=0;m<data.length;m++){
                this.items5 = [...this.items5, {value: data[m].values, label: data[m].label}];
            }
            this.errors5 = undefined;
            console.log('XXX Get Education List Rest =>'+JSON.stringify(this.items5));
        }else if(error){
            this.errors5 = error;
            console.log('XXX An error was occurred =>'+JSON.stringify(this.errors5));
        }
    }

    @wire(getEducationValues) wireEducationList({data,error}){
        if(data){
            for(l=0;l < data.length; l++){
                this.items4 = [...this.items4, {value: data[l].values, label: data[l].label}];
            }
            this.errors4 = undefined;
            console.log('XXX Get Education List =>'+JSON.stringify(this.items4));
        }else if(error){
            this.errors4 = error;
            console.log('XXX An error was occurred =>'+JSON.stringify(this.errors4));
        }
    }

    @wire(getPicklistValuesList) wireLanguagePick({data, error}){
        if(data){
            for(k=0;k<data.length;k++){
                this.itmes3 = [...this.itmes3, {value: data[k].values, label: data[k].label}];
            }
            this.errors3 = undefined;
        }else if(error){
            this.errors3 = error;
            console.log('XXX An error was occurred '+JSON.stringify(this.errors3));
        }
    }
    @wire(getAccTemplate, {recordId:'$receivedId'}) wireAccTemplateAccId({data, error})
        {
            if(data){
                for(j=0;j<data.length;j++){
                    this.items2 = [...this.items2, {value: data[j].Id, label: data[j].Name}];
                }
                this.errors2 = undefined;
            }else if(error){
                this.errors2 = error;
                console.log('XXX An error was occurred '+JSON.stringify(this.errors2));
            }
        }
    /*
    @wire(getContactRecordTypeNotIn) wireContactRecordTypeNotIn({data, error}){
        if(data){
            for(i=0;i<data.length;i++){
                this.items = [...this.items, {value: data[i].Id, label: data[i].Name}];
            }
            this.errors = undefined;
        }else if(error){
            this.errors = error;
            console.log('XXX An error was occurred');
        }
    }
    */
    @wire(getOtherRecType) wireContactOtherRecType({data, error}){
        if(data){
            for(i=0;i<data.length;i++){
                this.items = [...this.items, {value: data[i].values, label: data[i].label}]
            }
            this.errors = undefined;
        }else if(error){
            this.errors = error;
            console.log('XXX An error was occurred');
        }
    }

    get statusOptions(){
        return this.items;
    }

    get AccTemplateOptions(){
        return this.items2;
    }

    get LanguagePickOption(){
        return this.itmes3;
    }

    get EducationOptRest(){
        return this.items5;
    }
   
    get options(){
        return [
            { label : 'Ms.', value : 'Ms.'},
            { label : 'Herr', value : 'Herr'},
            { label : 'Frau', value : 'Frau'},
            { label : 'Prefer not to disclose', value : 'Prefer not to disclose'}
        ];
    }

    get optionEdu(){
        return [
            { label : 'MBO', value : 'MBO' },
            { label : 'HBO', value : 'HBO' }
        ];
    }

    goBackToStepOne() {
        this.currentStep = '1';

        this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        this.template
            .querySelector('div.stepOne')
            .classList.remove('slds-hide');
    }

    goToStepTwo() {
        if(this.lastname==null || this.lastname==''){
            alert('Please input data in LastName field');
        }else if(this.firstname==null || this.firstname==''){
            alert('Please input data in FirstName field');
        }else if(this.salut_value == null || this.salut_value == ''){
            alert('Please select Salutation Name');
        }else{
            this.currentStep = '2';

            this.template.querySelector('div.stepOne').classList.add('slds-hide');
            this.template
                .querySelector('div.stepTwo')
                .classList.remove('slds-hide');
        }
    }
    goBackToStepTwo() {
        this.currentStep = '2';

        this.template.querySelector('div.stepThree').classList.add('slds-hide');
        this.template
            .querySelector('div.stepTwo')
            .classList.remove('slds-hide');
    }
    goToStepThree() {
        if(this.RecordTypeValue==null || this.RecordTypeValue==''){
            alert('Please select for Contact Role');
        }else if(this.education==null || this.education==''){
            alert('Please select Education');
        }else{
            this.currentStep = '3';
            if(this.RecordTypeLabel == 'Shop Owner'){
                this.req = true;
            }else{
                this.req = false;
            }
            this.template.querySelector('div.stepTwo').classList.add('slds-hide');
            this.template
                .querySelector('div.stepThree')
                .classList.remove('slds-hide');
        }
    }
    goBackToStepThree(){
        this.currentStep = '3';
        this.template.querySelector('div.stepFour').classList.add('slds-hide');
        this.template
            .querySelector('div.stepThree')
            .classList.remove('slds-hide');
    }
    goToStepFour(){
        if(this.email == null || this.email == ''){
            alert('Please input Email, Email is neccessary field');
        }else{
            this.currentStep = '4';
            this.template.querySelector('div.stepThree').classList.add('slds-hide');
            this.template
                .querySelector('div.stepFour')
                .classList.remove('slds-hide');
            //this.template.querySelector('[data-my-id="stepPortal"]').classList.remove('slds-hide');
        }
    }
    handleClickCheck1(event){
        this.salut_value = 'Mr.';
        this.value=null;
        this.template.querySelector('lightning-combobox[data-my-id=OtherSalutation]').value=null;
        console.log('Salutation value '+JSON.stringify(this.salut_value));

    }
    handleClickCheck2(event){
        this.salut_value = 'Mrs.';
        this.value=null;
        this.template.querySelector('lightning-combobox[data-my-id=OtherSalutation]').value=null;
        console.log('Salutation value '+JSON.stringify(this.salut_value));
    }
    handleClickCheck3(event){
        this.salut_value = 'Dr.';
        this.value=null;
        this.template.querySelector('lightning-combobox[data-my-id=OtherSalutation]').value=null;
        console.log('Salutation value '+JSON.stringify(this.salut_value));
    }
    handleClickCheck4(event){
        this.salut_value = 'Prof.';
        this.value=null;
        this.template.querySelector('lightning-combobox[data-my-id=OtherSalutation]').value=null;
        console.log('Salutation value '+JSON.stringify(this.salut_value));
    }
    handleEduClick1(event){
        this.education = 'Optician';
        this.template.querySelector('lightning-combobox[data-my-id=OthEducation]').value=null;
        console.log('Education '+JSON.stringify(this.education));
    }
    handleEduClick2(event){
        this.education = 'Optometris';
        this.template.querySelector('lightning-combobox[data-my-id=OthEducation]').value=null;
        console.log('Education '+JSON.stringify(this.education));
    }
    handleEduClick3(event){
        this.education = 'Opthalmologist'
        this.template.querySelector('lightning-combobox[data-my-id=OthEducation]').value=null;
        console.log('Education '+JSON.stringify(this.education));
    }
    handleDropDownListChange(event){
        this.template.querySelector('lightning-input[data-my-id=mr]').checked=false;
        this.template.querySelector('lightning-input[data-my-id=mrs]').checked=false;
        this.template.querySelector('lightning-input[data-my-id=dr]').checked=false;
        this.template.querySelector('lightning-input[data-my-id=prof]').checked=false;

        this.template.querySelector('lightning-input[data-my-id=mr]').checked=null;
        this.template.querySelector('lightning-input[data-my-id=mrs]').checked=null;
        this.template.querySelector('lightning-input[data-my-id=dr]').checked=null;
        this.template.querySelector('lightning-input[data-my-id=prof]').checked=null;

        this.salut_value=event.target.value;
        console.log('Salutation value '+JSON.stringify(this.salut_value));
    }
    handleOptEducationChange(event){
        /*
        this.template.querySelector('lightning-input[data-my-id=optician]').checked = false;
        this.template.querySelector('lightning-input[data-my-id=optometris]').checked = false;
        this.template.querySelector('lightning-input[data-my-id=opthalmologist').checked = false;*/
        let selectRadio = this.template.querySelectorAll('lightning-input[data-my-id=Edulist]');
        selectRadio.forEach(row=>{
            if(row.type=='radio'){
                row.checked = false;
            }
        });
        this.education = event.target.value;
        console.log('Education '+JSON.stringify(this.education));

    }
    handleOptOthEducationClick(){
        this.template.querySelector('div.stepEducation').classList.remove('slds-hide');
    }
    handleEducationClick(event){
        this.education = event.target.value;
        this.template.querySelector('lightning-combobox[data-my-id=OthEducation]').value = null;
        this.template.querySelector('div.stepEducation').classList.add('slds-hide');
        console.log('Education Value '+JSON.stringify(this.education));
    }
    handleClickRcordType(event){
        this.RecordTypeValue = event.target.value;
        this.RecordTypeLabel = event.target.label;
        this.template.querySelector('lightning-combobox[data-my-id=comborectype]').value = null;
        this.template.querySelector('div.OtherRecType').classList.add('slds-hide');
        console.log('Record type id == >'+JSON.stringify(this.RecordTypeValue)+' label is =>'+JSON.stringify(this.RecordTypeLabel));

        if(this.RecordTypeLabel=='Shop Owner'){
            this.template.querySelector('[data-my-id="stepPortal"]').classList.remove('slds-hide');
            this.template.querySelector('[data-my-id="laststep"]').classList.remove('slds-hide');
            this.template.querySelector('[data-my-id="Commu"]').classList.add('slds-hide');
        }else{
            this.template.querySelector('[data-my-id="stepPortal"]').classList.add('slds-hide');
            this.template.querySelector('[data-my-id="laststep"]').classList.add('slds-hide');
            this.template.querySelector('[data-my-id="Commu"]').classList.remove('slds-hide');
        }
        /*
        let recType = this.template.querySelectorAll('lightning-input[data-key="recordtypeid"]');
        recType.forEach(currentItem=>{
            console.log(currentItem.label);
        });*/
    }
    handleOtherRecordType(){
        this.template.querySelector('div.OtherRecType').classList.remove('slds-hide');
    }
    handleRecordDropdown(event){
        this.RecordTypeValue = event.target.value;
        this.RecordTypeLabel = event.target.label;
        this.template.querySelector('[data-my-id="stepPortal"]').classList.add('slds-hide');
        this.template.querySelector('[data-my-id="laststep"]').classList.add('slds-hide');
        this.template.querySelector('[data-my-id="Commu"]').classList.remove('slds-hide');
        let deselected = this.template.querySelectorAll('lightning-input[data-key="recordtypeid"]');
        deselected.forEach(currentItem=>{
            if(currentItem.type==='radio'){
                currentItem.checked = false;
            }
            //console.log(currentItem.type);
            //console.log(currentItem.checked);
        });
        console.log('Record type id == >'+JSON.stringify(this.RecordTypeValue)+' label is =>'+JSON.stringify(event.target.label));
    }
    handleLanguageChange(event){
        this.languagepick = event.target.value;
        let LanguageP = event.target.value;
        let AccTemplate = this.AccountTemplate;
        if((AccTemplate!=null) && (LanguageP!=null)){
            this.template.querySelector('div.SendEmail').classList.remove('slds-hide');
        }
        console.log('XXX Get data from langauge pick == > '+JSON.stringify(this.languagepick));
    }
    handleAccTemplate(event){
        this.AccountTemplate = event.target.value;
        let AccTemplate = event.target.value;
        let languagePick = this.languagepick;
        if((AccTemplate!=null) && (languagePick!=null)){
            this.template.querySelector('div.SendEmail').classList.remove('slds-hide');
        }
        console.log('XXX Account template = > '+JSON.stringify(this.AccountTemplate));
    }
    handleFirstNameChange(event){
        this.firstname = event.target.value;
        console.log('XXX First name == > '+JSON.stringify(this.firstname));
    }
    handleLastNameChange(event){
        this.lastname = event.target.value;
        console.log('XXX Last Name == > '+JSON.stringify(this.lastname));
    }
    handleTitleChange(event){
        this.title = event.target.value;
        console.log('XXX Title == > '+JSON.stringify(this.title));
    }
    handlePhoneChange(event){
        this.phone = event.target.value;
        console.log('XXX Phoe == > '+JSON.stringify(this.phone));
    }
    handleMobileChange(event){
        this.mobilephone = event.target.value;
        console.log('XXX Mobile phone == > '+JSON.stringify(this.mobilephone));
    }
    handleEmailChange(event){
        this.email = event.target.value;
        console.log('Email =>'+JSON.stringify(this.email));
    }
    handleSendInvitePortal(event){
        if(this.template.querySelector('lightning-input[data-my-id=SendInvitePortal]').checked==true){
            this.SendInvitationImmediately = true;
        }else{
            this.SendInvitationImmediately = false;
        }
        console.log('Send email invitation immediately check = > '+JSON.stringify(this.SendInvitationImmediately));
    }
    handleSendInviteEmail(){
        if(this.template.querySelector('lightning-input[data-my-id=SendInviteImm]').checked==true){
            this.SendImmDiately = true;
        }else{
            this.SendImmDiately = false;
        }
        console.log('Checked system invitation => '+JSON.stringify(this.SendImmDiately));
    }
    handleCreatNewContact(){
        //this.isLoading = true;
        this.ButtonDisalbed();
        if(this.lastname==null || this.lastname==''){
            alert('Please input data in Lastname field');
        }else if(this.RecordTypeValue==null || this.RecordTypeValue==''){
            alert('Please select for Contact Role');
        }else if(this.firstname==null || this.firstname==''){
            alert('Please input FirstName value');
        }else if((this.RecordTypeLabel=='Shop Owner') && (this.email==null || this.email=='')){
            alert('Please input Email, Email is neccessary field');
        }else{
            createContact({
                accountid : this.receivedId,
                salutation : this.salut_value,
                firstname : this.firstname,
                lastname : this.lastname,
                title : this.title,
                recordtypeid : this.RecordTypeValue,
                education : this.education,
                phone : this.phone,
                mobile : this.mobilephone,
                email : this.email,
                accTemplate : this.AccountTemplate,
                //SystemInvitationEmail : this.SystemInvitationEmail,
                SendInvitationPortal : this.SendInvitationPortal,
                SendImmDiately : this.SendImmDiately
            }).then(result=>{
                this.message = 'New Contact Created';
                console.log('New Contact Created');
                this.updateRecordView();
                this.closePopup();
            }).catch(error=>{
                this.message = 'Error had occurred';
                console.log('Contact cannnot created');
            });
        }
    }
    closePopup() {
        //this.ButtonDisalbed();
        window.location.reload();
        this.close();
    }
    updateRecordView(){
        setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
        },1000);
    }

    ButtonDisalbed(){
        this.disabledButton = true;
    }
}