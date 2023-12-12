import { LightningElement, api,track,wire } from 'lwc';
import ACCOUNT_OBJ from '@salesforce/schema/Account';
// fields
import PORTAL from '@salesforce/schema/Account.Portal__c';
import LANGUAGE from '@salesforce/schema/Account.Language__c';
import BRAND_VISIBILITY from '@salesforce/schema/Account.Brand_Visibility__c';
import PARENT_ACCOUNT from '@salesforce/schema/Account.ParentId';
import Acc_NumAcc from '@salesforce/schema/Account.Account_Counter__c';
import getRegistratedContact from '@salesforce/apex/tabActivationPortalRegistration.getRegistratedContact';
import NumChildAccount from '@salesforce/apex/TabAccountMemberParentId.getNumberOfAllAccount';
import label_ContactName from '@salesforce/label/c.tabAccContactName';
import label_ContRecType from '@salesforce/label/c.tabAccContactRecType';
import label_email from '@salesforce/label/c.tabAccContactEmail';
import label_viewall from '@salesforce/label/c.ViewAllRelatedList';
import label_PortalName from '@salesforce/label/c.Portal_Name';
import label_ParentAccount from '@salesforce/label/c.ParentAccount';
import label_NonRegContact from '@salesforce/label/c.NonRegContactsInPortal';
import label_PortalRegContact from '@salesforce/label/c.PortalRegContact';
import { NavigationMixin } from 'lightning/navigation';
import label_EmailInvitationFlag from '@salesforce/label/c.EmailInvitationFlag';
import label_LastLogin from '@salesforce/label/c.LastLogin';
import label_PortalLogin from '@salesforce/label/c.PortalLogin';
import lblNumChild from '@salesforce/label/c.SFDC_V_2_AccountMembership_NumsChild';

import AI_Indicators from '@salesforce/resourceUrl/SFDC_V2_AI_Indicators';

export default class TabActivationPortalRegistration extends NavigationMixin(LightningElement) {
    @api receivedId;
    conCount='0';
    nonRegContactCount='0';
    objectapiname = ACCOUNT_OBJ;
    labelLastLogin = label_LastLogin;
    labelContactName = label_ContactName;
    labelContactRecType = label_ContRecType;
    labelContactEmail = label_email;
    isDataExists = false;
    labelEmailInvitationFlag=label_EmailInvitationFlag;
    isDataExistsForNonRegContact=false;
    portalAccFields=[PORTAL,LANGUAGE,BRAND_VISIBILITY];
    parentAccount=[PARENT_ACCOUNT];
    isShowViewAllButton=false;
    NumChild;
    errors2;
    isShowViewAllButtonForNonCon=false;

    RegistrationIndicator;
    SocialMediaIndicator;
    StoreFinderIndicator;
    InetIndicator;
    PurchaseRegistrationIndicator;
    LoyaltyProIndicator;

    @track sortBy='ContactRecordType';
    @track sortDirection='desc';
    @track registratedContactList;
    @track columns = [{
            label: this.labelContactName,fieldName: 'conLink',type: 'url',typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
            sortable: true},
        {
            label: this.labelContactRecType,fieldName: 'ContactRecordType',type: 'text',sortable: true
        },
        {
            label: this.labelEmailInvitationFlag ,fieldName: 'SystemInvitationEmail',type: 'boolean',sortable: true
        },
        {
            label: 'Registered',fieldName: 'Registered',type: 'boolean',sortable: true
        },
        {
            label: this.labelLastLogin,fieldName: 'LastLogin',type: 'text',sortable: true
        },
        {
            label: this.labelContactEmail,fieldName: 'Email',type: 'email',sortable: true
        }
        
    ];
    connectedCallback() {
        this.getRegistratedContact();
       // this.getNonRegistratedContact();

       // load grey indicators tempoprarily for demo
        this.RegistrationIndicator = AI_Indicators + '/'+ 'GreyLight.png';
        this.SocialMediaIndicator = AI_Indicators + '/'+ 'GreyLight.png';
        this.StoreFinderIndicator = AI_Indicators + '/'+ 'GreyLight.png';
        this.InetIndicator = AI_Indicators + '/'+ 'GreyLight.png';
        this.PurchaseRegistrationIndicator = AI_Indicators + '/'+ 'GreyLight.png';
        this.LoyaltyProIndicator = AI_Indicators + '/'+ 'GreyLight.png';

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

    @wire(NumChildAccount, {recordId : '$receivedId'})
    wireNumberOfChild({data, error}){
        if(data){
            this.NumChild = data[0];
            this.errors2 = undefined;
        }else if(error){
            this.NumChild = undefined;
            this.errors2 = error;
        }
    }
    get NumberOfChild(){
        return this.NumChild?.childAccount;
    }
    getRegistratedContact() {
        getRegistratedContact({receivedId: this.receivedId})
            .then(data => {
            if(data){
                data = JSON.parse(JSON.stringify(data));
                console.log('>>>>data',data);
                this.registratedContactList = data;
                if(this.registratedContactList.length>0){
                    this.isDataExists = true;
                    this.conCount= this.registratedContactList.length;
                    this.sortData(this.sortBy, this.sortDirection);
                    this.registratedContactList.forEach(res=>{
                        res.Name=  res.name;
                        res.conLink = '/' + res.Id;
                        res.ContactRecordType = res.RecordTypeName;
                        res.Email = res.Email;
                        res.SystemInvitationEmail = res.EmailFlag;
                        res.LastLogin = res.lastLogin;
                        res.Registered = res.RegistratedFlag;
                        
                    });
                    console.log('>>>registratedContactList',this.registratedContactList);
                    this.isShowDataTable= true; 
                }
                else{
                    this.conCount='0';
                    this.isShowViewAllButton=false;
                    console.log('>>>',this.conCount);}
                }else{this.isShowDataTable=false;}
            }).catch(error => {
               console.log('>>>>>',error.message);
            })
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
    navigateToRelatedNonRegContactList(){
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
    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        console.log('>>>>');
        let parseData = [...this.registratedContactList];
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'desc' ? 1: -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.registratedContactList = parseData;
    }  
    custLabel = {label_viewall,label_PortalName,label_ParentAccount,
                 label_PortalLogin,label_NonRegContact,label_PortalRegContact,lblNumChild};

}