import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';


import Instore_Training_And_Webinars from '@salesforce/label/c.Instore_Training_And_Webinars';
import ECP_Training_Name from '@salesforce/label/c.ECP_Training_Name';
import Training_Topic from '@salesforce/label/c.Training_Topic';
import Start from '@salesforce/label/c.start';
import Training_Status from '@salesforce/label/c.Training_Status';
import e_learnings from '@salesforce/label/c.e_learnings';
import e_learnings_name from '@salesforce/label/c.e_learnings_name';
import Created_Date from '@salesforce/label/c.Created_Date';
import User_Name from '@salesforce/label/c.User_Name';
import e_Email from '@salesforce/label/c.e_Email';
import e_status from '@salesforce/label/c.e_status';
import End_Date from '@salesforce/label/c.End_Date';
import label_viewall from '@salesforce/label/c.ViewAllRelatedList';
import label_new from '@salesforce/label/c.NewButtonRelatedList'; 

import getTrainingRecord from '@salesforce/apex/TabVisitsTrainingsController.getTrainingRecords';
import getElearningRecords from '@salesforce/apex/TabVisitsTrainingsController.getElearningRecords';

export default class TabVisitsTrainings extends NavigationMixin(LightningElement) {
    @api receivedId;
    trainingRecords;
    elarningRecords;
    trainingCount = 0;
    eLearningCount = 0;
    displayTrainingViewAllButton = false;
    displayElearningViewAllButton = false;
    subscription = {};
    CHANNEL_NAME = '/event/Refresh_Related_list_Training__e';
  
    label = {Instore_Training_And_Webinars,ECP_Training_Name,Training_Topic,Start,Training_Status,e_learnings,e_learnings_name,
        e_learnings_name,Created_Date,User_Name,e_Email,e_status,End_Date, label_viewall,label_new}

   @track trainingColumns = [
    {
        label: this.label.ECP_Training_Name,
        fieldName: 'nameLink',
        type: 'url',
        typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
        sortable: true
      },
      {
        label: this.label.Training_Topic,
        fieldName: 'Training__c',
        type: 'text',
        sortable: true,
        wrapText: true
      },
      {
        label: this.label.Start,
        fieldName: 'start__c',
        type: 'date',
        sortable: true
      },
      {
        label: this.label.Training_Status,
        fieldName: 'Training_status__c',
        type: 'text',
        sortable: true
      },
   ]

   @track elarningColumns = [
    {
        label: this.label.e_learnings_name,
        fieldName: 'nameLink',
        type: 'url',
        typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
        sortable: true
      },
      {
        label: this.label.Created_Date,
        fieldName: 'CreatedDate',
        type: 'date',
        sortable: true
      },
      {
        label: this.label.User_Name,
        fieldName: 'User_Name__c',
        type: 'text',
        sortable: true
      },
      {
        label: this.label.e_Email,
        fieldName: 'email__c',
        type: 'text',
        sortable: true
      },
      {
        label: this.label.e_status,
        fieldName: 'status__c',
        type: 'text',
        sortable: true
      },
      {
        label: this.label.End_Date,
        fieldName: 'End_Date__c',
        type: 'date',
        sortable: true
      }
   ]
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        console.log('child connected call-' + this.receivedId);
        this.getTrainingRecordsFromApex();
        subscribe(this.CHANNEL_NAME, -1, this.refreshList).then(response => {
          this.subscription = response;
          console.log('RefreshList is called 99');
        });
        onError(error => {
            console.error('Server Error--->'+error);
        });
    }
    refreshList = ()=> {
      this.getTrainingRecordsFromApex();
      console.log('>>>>here');
  } 

/*  //wire service is not working
    @wire(getTrainingRecord, {accountId:'$receivedId'}) trainingRec({error, data}){
      console.log('training records'+JSON.stringify(data))
      if(data && data.length > 0){
        data = JSON.parse(JSON.stringify(data));
        data.forEach(res=>{
            res.nameLink = '/' + res.Id;
        });

        let allTrainingRecords=data;
        this.trainingRecords = (allTrainingRecords.length <= 5) ? [...allTrainingRecords] : [...allTrainingRecords].splice(0,5);
        console.log('trainingRecords records'+JSON.stringify(trainingRecords))
        if(allTrainingRecords.length > 5){
            this.trainingCount='5+';
            this.displayTrainingViewAllButton = true;
          }
          else{
            console.log('training records'+JSON.stringify(data))
              this.trainingCount = allTrainingRecords.length;
              this.displayTrainingViewAllButton = false;
          }
      }else if (error){
        this.showToast('Error','Error While fetching the Training Records'+error.message,'error');
    }
  }*/

  getTrainingRecordsFromApex(){
    getTrainingRecord({accountId:this.receivedId}).then(result=>{
          if(result){
            let data = JSON.parse(JSON.stringify(result));
            console.log('>>>>here2',data);
            data.forEach(res=>{
                res.nameLink = '/' + res.Id;
            });
        
            let allTrainingRecords = data;
            this.trainingRecords = (allTrainingRecords.length <= 5) ? [...allTrainingRecords] : [...allTrainingRecords].splice(0,5);
              if(allTrainingRecords.length > 5){
                this.trainingCount='5+';
                this.displayTrainingViewAllButton = true;
              }
              else{
                  this.trainingCount = allTrainingRecords.length;
                  this.displayTrainingViewAllButton = false;
              }
          }
        }).catch(error=>{
          this.showToast('Error','Error While fetching the Training Records'+error.message,'error');
        })
      }

  @wire(getElearningRecords, {accountId:'$receivedId'}) trainingRec({error, data}){
    if(data){
      data = JSON.parse(JSON.stringify(data));
      data.forEach(res=>{
          res.nameLink = '/' + res.Id;
      });

      let allElearningRecords=data;
      this.elarningRecords = (allElearningRecords.length <= 5) ? [...allElearningRecords] : [...allElearningRecords].splice(0,5);
                
      if(allElearningRecords.length > 5){
          this.eLearningCount='5+';
          this.displayElearningViewAllButton = true;
        }
        else{
            this.eLearningCount = allElearningRecords.length;
            this.displayElearningViewAllButton = false;
        }
    }else if (error){
      this.showToast('Error','Error While fetching the E-learning Records'+error.message,'error');
  }
}
  
  showToast(title,message,variant) {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
    });
    this.dispatchEvent(event);
  }

  navigateToRelatedList(relationshipName){
    this[ NavigationMixin.GenerateUrl ]({
        type : 'standard__recordRelationshipPage',
        attributes : {
            recordId : this.receivedId,
            objectApiName : 'Account',
            relationshipApiName : relationshipName,
            actionName : 'view'
        }
    }).then(url => {
        window.open(url, '_blank');
    });
}

    navigateToTrainingRelatedList(event){
      this.navigateToRelatedList('ECP_Training__r');
    }

    navigateToELearningRelatedList(event){
      this.navigateToRelatedList('eLearnings__r');
    }

    navigateToTrainingCreatePage(event){
      this.navigateToNewPage('ECP_Training__c');
    }

    navigateToNewPage(objectName){
      const defaultValues = encodeDefaultFieldValues({
        Account__c : this.receivedId
      });
      console.log(defaultValues);
      this[ NavigationMixin.Navigate]({
          type : 'standard__objectPage',
          attributes : {
              objectApiName : objectName,
              actionName : 'new'
          },
          state: {
              defaultFieldValues: defaultValues,
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