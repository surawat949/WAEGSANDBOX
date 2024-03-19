import { LightningElement, api, wire, track } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import PickListMiyoSmartAttitude from '@salesforce/apex/TabMVCVisitsContactNearby.getPickListMiyoSmartAttitude';
import PicklistPrescriptionPotential from '@salesforce/apex/TabMVCVisitsContactNearby.getPicklistPrescriptionPotential';
import PicklistPreferredContact from '@salesforce/apex/TabMVCVisitsContactNearby.getPicklistPreferredContact';
import PicklistFirstSpeciality from '@salesforce/apex/TabMVCVisitsContactNearby.getPicklistFirstSpeciality';
import PicklistProfessionalType from '@salesforce/apex/TabMVCVisitsContactNearby.getPicklistProfessionalType';
import PicklistPreferredDayTime from '@salesforce/apex/TabMVCVisitsContactNearby.getPreferredDayTime';
import getContactsNearby from '@salesforce/apex/TabMVCVisitsContactNearby.gettAllContacts';

/**this section for custom label */
import lblMyoAttitude from '@salesforce/label/c.SFDC_V2_MVC_Visits_ContactNearby_MyoAttitude';
import lblPreferredContact from '@salesforce/label/c.SFDC_V2_MVC_Visits_ContactNearby_Preferred';
import lblDistance from '@salesforce/label/c.SFDC_V2_MVC_Visits_ContactNearby_Distance';
import lblPrescription from '@salesforce/label/c.SFDC_V2_MVC_Visits_ContactNearby_Prescription';
import lblFirstSpeciality from '@salesforce/label/c.SFDC_V2_MVC_Visits_ContactNearby_FirstSpeciality';
import lblProfessionalType from '@salesforce/label/c.SFDC_V2_MVC_Visits_ContactNearby_ProfessionalType';
/**End */

export default class TabMVCVisitsContactNearby extends LightningElement {
    @api receivedId;
    
    items1 = [{label : 'No Filter', value : 'No Filter'}];      //for picklist value MiyoSmart Attitude
    errors1;

    items2 = [{label : 'No Filter', value : 'No Filter'}];      //for picklist Prescription Potential
    errors2;

    items3 = [{label : 'No Filter', value : 'No Filter'}];      //for picklist Preferred Contact
    errors3;

    itmes4 = [{label : 'No Filter', value : 'No Filter'}];      //for picklist Speciality
    errors4;

    items5 = [{label : 'No Filter', value : 'No Filter'}];      //for picklist Professional Type
    errors5;

    items6 = [];
    errors6;

    errors7;        //this is about for store error text in map markers

    @track isMyoSmart = false;
    @track MyoSmartAttitude = '';
    @track PreferredContactMethod = '';
    @track distanceSlider = '5';
    @track PrescriptionPotential = '';
    @track FirstSpeciality = '';
    @track ProfessionalType = '';
    @track mapMarkers = [];
    @track markersTitle = 'Contact Nearby';
    @track vcenter;
    @track zoomlevel = 9;
    @track isDisplayList = true;

    workTime = '';

    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        //console.log('child connected call-' + this.receivedId);
        this.handleKeyMapChange();
    }

    handleKeyMapChange(){
        getContactsNearby({ContactId : this.receivedId, distance : Math.floor(this.distanceSlider), miyoSmartAttitude : this.MyoSmartAttitude, prescriptionPotential : this.PrescriptionPotential, preferredMethod : this.PreferredContactMethod, firstSpeciality : this.FirstSpeciality, professional : this.ProfessionalType, PreferDayTime : this.workTime})
        .then(result=>{
            this.mapMarkers = [];
			if(result.length > 0){
				for(var i=0;i<result.length;i++){
					if(i==0){
						let AccountName = '';
						let ContactName = '';
						let MiyoSmartAttitude = '';
						let lastvisiteddate = '';
						let preferContactMethod = '';
						let mailingCity = '';
						let mailingStreet = '';
						let mailingPostalcode = '';
                        let ClinicName = '';
                        let lastname = '';
                        let firstname = '';

						if(result[i].MiyoSmart_Attitude__c!=undefined){
							MiyoSmartAttitude = result[i].MiyoSmart_Attitude__c;
						}

						if(result[i].Last_contact_visit_date__c!=undefined){
							lastvisiteddate = result[i].Last_contact_visit_date__c;
						}

						if(result[i].Preferred_contact_method__c!=undefined){
							preferContactMethod = result[i].Preferred_contact_method__c;
						}
						if(result[i].MailingStreet!=undefined){
							mailingStreet = result[i].MailingStreet;
						}
						if(result[i].MailingCity!=undefined){
							mailingCity = result[i].MailingCity;
						}
						if(result[i].MailingPostalCode!=undefined){
							mailingPostalcode = result[i].MailingPostalCode;
						}

						if(result[i].Account.Name != undefined){
							AccountName = result[i].Account.Name;
						}

                        if(result[i].LastName != undefined){
                            lastname = result[i].LastName;
                        }

                        if(result[i].FirstName != undefined){
                            firstname = result[i].FirstName;
                        }

						ContactName = lastname+', '+firstname;

                        if(result[i].Account.Clinic_Name__c != undefined){
                            ClinicName = result[i].Account.Clinic_Name__c;
                        }


						this.mapMarkers = [...this.mapMarkers,
                        {
                            location : {
                                Latitude : result[i].MailingLatitude,
                                Longitude : result[i].MailingLongitude,
                                Street : result[i].MailingStreet,
                                City : result[i].MailingCity,
                                State : result[i].MailingState,
                                Country : result[i].MailingCountry,
                                PostalCode : result[i].MailingPostalCode
                            },
                            mapIcon : {
                                path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                                fillColor: '#CF3476',
                                fillOpacity: .5,
                                strokeWeight: 1,
                                scale: .10,             //blue star pin for first record
                            },
                            icon : 'standard:contact',
                            title : ContactName,
                            value : result[i].Id,
                            description : 'MiyoSmart Attitude : '+MiyoSmartAttitude+'<br>'+'Last Contact Visit Day : '
                                            +lastvisiteddate+'<br>'+'Preferred Contact Method : '
                                            +preferContactMethod+'<br>'+'Related Account Name : '+ClinicName
                                            +'<br>'+'Contact Address : '+mailingStreet+ ' '+mailingCity+ ' '+mailingPostalcode,

							}
						];
					}else{
						let AccountName = '';
						let ContactName = '';
						let MiyoSmartAttitude = '';
						let lastvisiteddate = '';
						let preferContactMethod = '';
						let mailingCity = '';
						let mailingStreet = '';
						let mailingPostalcode = '';
                        let ClinicName = '';
                        let lastname = '';
                        let firstname = '';

						if(result[i].MiyoSmart_Attitude__c!=undefined){
							MiyoSmartAttitude = result[i].MiyoSmart_Attitude__c;
						}

						if(result[i].Last_contact_visit_date__c!=undefined){
							lastvisiteddate = result[i].Last_contact_visit_date__c;
						}

						if(result[i].Preferred_contact_method__c!=undefined){
							preferContactMethod = result[i].Preferred_contact_method__c;
						}
						if(result[i].MailingStreet!=undefined){
							mailingStreet = result[i].MailingStreet;
						}
						if(result[i].MailingCity!=undefined){
							mailingCity = result[i].MailingCity;
						}
						if(result[i].MailingPostalCode!=undefined){
							mailingPostalcode = result[i].MailingPostalCode;
						}

                        if(result[i].LastName != undefined){
                            lastname = result[i].LastName;
                        }

                        if(result[i].FirstName != undefined){
                            firstname = result[i].FirstName;
                        }

						if(result[i].Account.Name != undefined){
							AccountName = result[i].Account.Name;
						}

                        ContactName = lastname+', '+firstname;
						

                        if(result[i].Account.Clinic_Name__c != undefined){
                            ClinicName = result[i].Account.Clinic_Name__c;
                        }


						this.mapMarkers = [...this.mapMarkers,
                        {
                            location : {
                                Latitude : result[i].MailingLatitude,
                                Longitude : result[i].MailingLongitude,
                                Street : result[i].MailingStreet,
                                City : result[i].MailingCity,
                                State : result[i].MailingState,
                                Country : result[i].MailingCountry,
                                PostalCode : result[i].MailingPostalCode
                            },
                            mapIcon : {
                                path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                                fillColor: '#0000FF',
                                fillOpacity: 1,
                                strokeWeight: 1.1,
                                scale: 1.5,             //blue pin for first record
                            },
								icon : 'standard:contact',
								title : ContactName,
								value : result[i].Id,
								description : 'MiyoSmart Attitude : '+MiyoSmartAttitude+'<br>'+'Last Contact Visit Day : '
                                            +lastvisiteddate+'<br>'+'Preferred Contact Method : '
                                            +preferContactMethod+'<br>'+'Related Account Name : '+ClinicName
                                            +'<br>'+'Contact Address : '+mailingStreet+ ' '+mailingCity+ ' '+mailingPostalcode,

						}
						];
					}
				}

				this.vcenter = {
					location : {
						Latitude : result[0].MailingLatitude,
						Longitude : result[0].MailingLongitude,
						Street : result[0].MailingStreet,
						City : result[0].MailingCity,
						State : result[0].MailingState,
						Country : result[0].MailingCountry,
						PostalCode : result[0].MailingPostalCode
					},
				};
			}else{
				this.showToast('Warning', 'warning', 'Address details is missing');
			}
        })
        .catch(error=>{
            this.errors7 = error;
            this.showToast('Error', 'error', JSON.stringify(this.errors7));
        });
    }

    handleKeyChange(event) {
        // Get the list of the "value" attribute on all the selected options
        if(event.target.name === 'picklistMyoSmart'){
            this.MyoSmartAttitude = event.target.value;
            //console.log('XXX MiyoSmart Attitude Value =>'+JSON.stringify(this.MyoSmartAttitude));

            this.handleKeyMapChange();
        }

        if(event.target.name === 'picklistPreferredContact'){
            this.PreferredContactMethod = event.target.value;
            //console.log('XXX Preferred Contact Method =>'+JSON.stringify(this.PreferredContactMethod));

            this.handleKeyMapChange();
        }

        if(event.target.name === 'distance'){
            this.distanceSlider = event.target.value;
            //console.log('XXX Distance Value =>'+JSON.stringify(this.distanceSlider));

            this.handleKeyMapChange();
        }

        if(event.target.name === 'picklistPotential'){
            this.PrescriptionPotential = event.target.value;
            //console.log('XXX Prescription Potential Value =>'+JSON.stringify(this.PrescriptionPotential));

            this.handleKeyMapChange();
        }

        if(event.target.name === 'FirstSpeciality'){
            this.FirstSpeciality = event.target.value;
           // console.log('XXX First Speciality Value =>'+JSON.stringify(this.FirstSpeciality));

            this.handleKeyMapChange();
        }

        if(event.target.name === 'ProfessionalType'){
            this.ProfessionalType = event.target.value;
            //console.log('XXX Prefessional Type Value =>'+JSON.stringify(this.ProfessionalType));

            this.handleKeyMapChange();
        }

        if(event.target.name==='PreferredContactDayTime'){
            var selectedOptionsList = event.detail.value;
            let abc = '';
            selectedOptionsList.forEach(element => {
                abc = abc + element + ';';
            });
            abc = abc.substring(0,abc.lastIndexOf(';'));
            this.workTime = abc;
            //console.log(this.workTime);

            this.handleKeyMapChange();
        }
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

    @wire(PickListMiyoSmartAttitude) wirePicklistMiyoSmartAttitude({data, error}){
        if(data){
            for(var i=0;i<data.length;i++){
                this.items1 = [...this.items1, {label : data[i].label, value : data[i].values}];
            }
            this.errors1 = undefined;
        }else if(error){
            this.data = undefined;
            this.errors1 = error;
            this.showToast('Error', 'error', JSON.stringify(this.errors1));
        }
    }

    @wire(PicklistPrescriptionPotential) wirePicklistPrescriptionPotential({data, error}){
        if(data){
            for(var i=0;i<data.length;i++){
                this.items2 = [...this.items2, {label : data[i].label, value : data[i].values}];
            }
            this.errors2 = undefined;
        }else if(error){
            this.data = undefined;
            this.errors2 = error;
            this.showToast('Error', 'error', JSON.stringify(this.errors2));
        }
    }

    @wire(PicklistPreferredContact) wirePickListPreferredContact({data, error}){
        if(data){
            for(var i=0;i<data.length;i++){
                this.items3 = [...this.items3, {label : data[i].label, value : data[i].values}];
            }
            this.errors3 = undefined;
        }else if(error){
            this.data = undefined;
            this.errors3 = error;
            this.showToast('Error', 'error', JSON.stringify(this.errors3));
        }
    }

    @wire(PicklistFirstSpeciality) wirePicklistFirstSpeciality({data, error}){
        if(data){
            for(var i=0;i<data.length;i++){
                this.itmes4 = [...this.itmes4, {label : data[i].label, value : data[i].values}];
            }
            this.errors4 = undefined;
        }else if(error){
            this.data = undefined;
            this.errors4 = error;
            this.showToast('Error', 'error', JSON.stringify(this.errors4));
        }
    }

    @wire(PicklistProfessionalType) wirePicklistProfessional({data, error}){
        if(data){
            for(var i=0;i<data.length;i++){
                this.items5 = [...this.items5, {label : data[i].label, value : data[i].values}];
            }
            this.errors5 = undefined;
        }else if(error){
            this.data = undefined;
            this.errors5 = error;
            this.showToast('Error', 'error', JSON.stringify(this.errors5));
        }
    }

    @wire(PicklistPreferredDayTime) wirePicklistPreferredDayTime({data, error}){
        if(data){
            for(var i=0;i<data.length;i++){
                this.items6 = [...this.items6, {label : data[i].label, value : data[i].values}];
            }
            this.errors6 = undefined;
            //console.log('XXX Get Multi-picklist values=>'+JSON.stringify(data));
        }else if(error){
            this.data = undefined;
            this.errors6 = error;
            this.showToast('Error', 'error', JSON.stringify(this.errors6));
        }
    }

    get picklistMyoAttitude(){
        return this.items1;
    }

    get picklistPreferredContact(){
        return this.items3;
    }

    get picklistPrescriptionPotential(){
        return this.items2;
    }

    get picklistSpciality(){
        return this.itmes4;
    }

    get picklistProfessionalType(){
        return this.items5;
    }

    get picklistPreferredDayTime(){
        return this.items6;
    }

    handleListViewShow(){
        this.displayListView = 'visible';
        this.isDisplayList = false;
    }

    handleListViewHide(){
        this.displayListView = 'hidden';
        this.isDisplayList = true;
    }
    
    label = {lblMyoAttitude, lblPreferredContact, lblDistance, lblPrescription, lblFirstSpeciality, lblProfessionalType};
}