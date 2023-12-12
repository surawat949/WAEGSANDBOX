/**
 * @filename : tabMVAContactDetails
 * @description : tabMVAContactDetails to support Account Address in SFDC V.2.0 Project
 * @Author : Surawat Sakulmontreechai
 * @Group : Contact MVA Clinic
 * @CreatedBy : Surawat Sakulmontreechai
 * @CreatedDate : 2023-07-14
 * @LastModifiedBy : Surawat Sakulmontreechai
 * @LastModifiedDate : -
 * @Email : surawat.sakulmontreechai@hoya.com
 * @NotedAndDeescription :  For the tab MVC Contact clinic record details - address include
 *                          IQVIA
 * 
 */

import { LightningElement, api, track } from 'lwc';

import Contact_Name from '@salesforce/schema/Contact.Name';
import Contact_FirstSpeciality from '@salesforce/schema/Contact.First_Speciality__c';
import Contact_SecondSpeciality from '@salesforce/schema/Contact.Secn_Speciality__c';
import Contact_ThirdSpeciality from '@salesforce/schema/Contact.Third_Specialization__c';
import Contact_Title from '@salesforce/schema/Contact.Title';
import Contact_CurrentState from '@salesforce/schema/Contact.Current_State__c';
import Contact_lawEnable from '@salesforce/schema/Contact.QIDC__OK_MDM_Is_Privacy_Law_Enabled_IMS__c';
import Contact_ProfessionalType from '@salesforce/schema/Contact.Professional_Type__c';
import Contact_OneKeyId from '@salesforce/schema/Contact.OnekeyId__c';
import Contact_Individual from '@salesforce/schema/Contact.Individual_Status__c';
import Contact_Professional_Title from '@salesforce/schema/Contact.Professional_Type__c';
import Contact_RecType from '@salesforce/schema/Contact.Contact_Record_Type__c';
import Contact_Specialization from '@salesforce/schema/Contact.Specialization__c';
import Contact_Education from '@salesforce/schema/Contact.Education__c';
import Contact_ReportTo from '@salesforce/schema/Contact.ReportsToId';
import Contact_Influence from '@salesforce/schema/Contact.Influence__c';
import Contact_HealthNationalId from '@salesforce/schema/Contact.Health_National_ID__c';
import Contact_Note from '@salesforce/schema/Contact.Additional_Notes_on_Contact__c';
import Contact_DoNotCall from '@salesforce/schema/Contact.DoNotCall';
import Contact_Donotvisit from '@salesforce/schema/Contact.Do_not_visit__c';
import Contact_PreferContact from '@salesforce/schema/Contact.Preferred_contact_method__c';
import Contact_ProfTitle from '@salesforce/schema/Contact.Title';
//import Contact_PreferDayTime from '@salesforce/schema/Contact.Preferred_contact_day_time__c';
import Contact_Phone from '@salesforce/schema/Contact.Phone';
import Contact_Mobile from '@salesforce/schema/Contact.MobilePhone';
import Contact_Fax from '@salesforce/schema/Contact.Fax';
import Contact_FaxOutOpp from '@salesforce/schema/Contact.HasOptedOutOfFax';
import Contact_appointment from '@salesforce/schema/Contact.By_appointment_only__c';
import Contact_Email from '@salesforce/schema/Contact.Email';
import Contact_EmailOptOut from '@salesforce/schema/Contact.HasOptedOutOfEmail';
import Contact_AcceptLunch from '@salesforce/schema/Contact.Accept_Lunches__c';
import Contact_AcceptTraining from '@salesforce/schema/Contact.Accept_Trainings__c';
import Contact_AcceptRoundTable from '@salesforce/schema/Contact.Accept_Round_Tables__c';
import ContactObj from '@salesforce/schema/Contact';

import label_IQVIADB from '@salesforce/label/c.SFDC_V_2_tabMVCContactDetails_IQVIA';
import label_LocalDB from '@salesforce/label/c.SFDC_V2_MVC_Contact_Details_LocalDB';
import label_communication from '@salesforce/label/c.SFDC_V2_MVC_Contact_Details_Comm';

export default class TabMVCContactDetails extends LightningElement {
    @api receivedId;

    @track isLoading;
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }

    connectedCallback() {
        //console.log('child connected call-' + this.receivedId);
    }

    contactObj = ContactObj;
    contactName = Contact_Name;
    contactFirstSpecial = Contact_FirstSpeciality;
    contactSecodSpecial = Contact_SecondSpeciality;
    contactThirdSpecial = Contact_ThirdSpeciality;
    contactTitle = Contact_Title;
    contactCurrentState = Contact_CurrentState;
    contactLawEnable = Contact_lawEnable;
    contactProfessionalType = Contact_ProfessionalType;
    contactOnekeyId = Contact_OneKeyId;
    contactIndividual = Contact_Individual;
    contactProfessionalTitle = Contact_Professional_Title;
    contactProfTitle = Contact_ProfTitle;
    
    LocalDBFields = [Contact_RecType, Contact_Specialization, Contact_Education, Contact_ReportTo, Contact_Influence, Contact_HealthNationalId, Contact_Note];
    CommunicationFields1 = [Contact_PreferContact, Contact_Phone, Contact_Donotvisit];
    CommunicationFields2 = [Contact_Fax, Contact_FaxOutOpp];
    CommunicationFields3 = [Contact_appointment, Contact_Email, Contact_EmailOptOut, Contact_AcceptLunch, Contact_AcceptTraining, Contact_AcceptRoundTable];
    CommunicationFields4 = [Contact_Mobile, Contact_DoNotCall];

    label = {label_IQVIADB, 
            label_LocalDB,
            label_communication};
    
}