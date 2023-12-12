/**
 * @filename : tabAccountAddressToCreateNewTaskModal
 * @description : tabAccountAddress.html to support Account Address in SFDC V.2.0 Project
 * @Author : Surawat Sakulmontreechai
 * @Group : Account Tab
 * @CreatedBy : Surawat Sakulmontreechai
 * @CreatedDate : 2023-06-17
 * @LastModifiedBy : Surawat Sakulmontreechai
 * @LastModifiedDate : 2023-06-20
 * @Email : surawat.sakulmontreechai@hoya.com
 * @Noted & description :   demand of modification of the account, emphasis on account edit and
 *                          once finished, system will assigned the task to someone else
 */
import { LightningElement, api, track, wire } from 'lwc';

import label_relatedTo from '@salesforce/label/c.tabTaskModalRelatedTo';
import label_newTask from '@salesforce/label/c.tabTaskModalNewTask';
import label_AccContact from '@salesforce/label/c.tabTaskModalAccContact';
import label_subject from '@salesforce/label/c.tabTaskModalSubject';
import label_comment from '@salesforce/label/c.tabTaskModalComment';
import label_assignedTo from '@salesforce/label/c.tabTaskModalAssignedTo';
import label_duedate from '@salesforce/label/c.tabTaskModalDueDate';
import label_copyTo from '@salesforce/label/c.tabTaskModalCopyTo';
import label_status from '@salesforce/label/c.tabTaskModalStatus';
import label_searchContact from '@salesforce/label/c.tabLabelSearchContact';
import label_searchUser from '@salesforce/label/c.tabLabelSearchUser';
import label_save from '@salesforce/label/c.tabLabelSave';
import label_Close from '@salesforce/label/c.tabLabelClose';
import label_instruction from '@salesforce/label/c.SFDC_V_2_Account_Membership_Instruction';

import createTask from '@salesforce/apex/tabAccountAddressLWCController.createTask';
//import AccountName from '@salesforce/schema/Account.Name';
import strusrId from '@salesforce/user/Id';
import copytoId from '@salesforce/user/Id';
import LightningModal from 'lightning/modal';
//import Account from '@salesforce/schema/Case.Account';

export default class TabAccountAddressToCreateNewTaskModal extends LightningModal{
    //@api fields;
    @api receivedId;
    errors;
    @track value='Nicht begonnen';
    labelRelatedTo = label_relatedTo;
    labelNewTask = label_newTask;
    labelAccContact = label_AccContact;
    labelSubject = label_subject;
    labelComment = label_comment;
    labelAssignedTo = label_assignedTo;
    labelDueDate = label_duedate;
    labelCopyTo = label_copyTo;
    labelStatus = label_status;
    labelSave = label_save;
    labelClose = label_Close;
    labelSearchUser = label_searchUser;
    labelSearchContact = label_searchContact;
    labelInstruction = label_instruction;
    userId = strusrId;
    copiedtoId = copytoId;

    Subject;
    WhatId = this.receivedId;
    Description;
    OwnerId;
    ActivityDate;
    Status = this.value;
    ContactName;
    CopyTo = this.copiedtoId;
    AccountId = this.receivedId;

    get options(){
        return [
            { label : 'Not Started', value : 'Nicht begonnen'},
            { label : 'On Going', value : 'In Progress'},
            { label : 'Completed', value : 'Completed'}
        ];
    }

    subjectCH(event){
        this.Subject = event.target.value;
        if(this.Subject == null || this.Subject == ''){
            alert('Subject must key-in, please complete subject field');
        }
    }
    whatIdCH(event){
        this.WhatId = event.target.value;
        
    }
    descriptionCH(event){
        this.Description = event.target.value;
    }
    ownerIdCH(event){
        this.OwnerId = event.target.value;
    }
    activityDateCH(event){
        this.ActivityDate = event.target.value;
    }
    statusCH(event){
        this.Status = event.target.value;
        this.Status = event.detail.value;
        console.log('XXX Selected Value == > '+event.detail.value);
    }
    contactCH(event){
        this.ContactName = event.target.value;
        console.log('XXX Selected Contact Id == > '+event.target.value);
    }
    copyToCH(event){
        this.CopyTo = event.target.value;
        console.log('XXX Select Copy To == > '+event.target.value);
    }
    closePopupSuccess(event) {
        this.close(event.detail.id);
    }

    closePopup() {
        this.close();
    }

    handleCreateTask(){
        if(this.Subject=='' || this.Subject==null){
            alert('Subject must have the value, please input some values Subject field');
        }else if(this.OwnerId=='' || this.OwnerId==null){
            alert('Assigned to must have the value, please select Assighed to field');
        }else{
            createTask({
                Sject : this.Subject,
                relatedTo : this.receivedId,
                Comment : this.Description,
                assignTo : this.OwnerId,
                DueDate : this.ActivityDate,
                sStatus : this.Status,
                sFlowContact : this.ContactName,
                CopyTo : this.CopyTo,
                AccountId : this.receivedId
            }).then(result=>{
                this.message = 'Task Created';
                //this.updateRecordView();
                console.log('Task Created');
                this.closePopup();
                this.updateRecordView();
            }).catch(error=>{
                this.message = 'Error Creating Task';
                console.log('Error during task creation');
            });
        }
    }

    handleLookupSelectionWhatId(event){
        if(event.detail.selectedRecord != undefined){
            console.log('Selected Record Value on Parent Component is ' +  
            JSON.stringify(event.detail.selectedRecord));
            //alert(event.detail.selectedRecord.Id + ' '+ event.detail.selectedRecord.Name);
            this.WhatId = event.detail.selectedRecord.Id;
            /*
            this.OwnerId = event.detail.selectedRecord.Id;
            this.ContactName = event.detail.selectedRecord.Id;
            this.CopyTo = event.detail.selectedRecord.Id;
            */
            this.template.querySelector('lightning-input[data-my-id=form-input-1]').value=event.detail.selectedRecord.Id;
            //this.template.querySelector('lightning-input[data-my-id=form-input-5]').value=event.detail.selectedRecord.Id;
            //this.template.querySelector('lightning-input[data-my-id=form-input-2]').value=event.detail.selectedRecord.Id;
            //this.template.querySelector('lightning-input[data-my-id=form-input-7]').value=event.detail.selectedRecord.Id;
        }
    }
    handleLookupSelectionOwnerId(event){
        if(event.detail.selectedRecord != undefined){
            console.log('Select contactid value on parent component is '+JSON.stringify(event.detail.selectedRecord.Id));
            this.OwnerId = event.detail.selectedRecord.Id;
            this.template.querySelector('lightning-input[data-my-id=form-input-5]').value=event.detail.selectedRecord.Id;
        }
    }
    handleLookupSelectionCopiedTo(event){
        if(event.detail.selectedRecord != undefined){
            console.log('Select copied to id value on parent component is '+JSON.stringify(event.detail.selectedRecord));
            this.CopyTo = event.detail.selectedRecord.Id;
            this.template.querySelector('lightning-input[data-my-id=form-input-7]').value=event.detail.selectedRecord.Id;
        }
    }
    handleLookupSelectionAccounContact(event){
        if(event.detail.selectedRecord != undefined){
            console.log('Select Account Contact id value on parent component is '+JSON.stringify(event.detail.selectedRecord.Id));
            this.ContactName = event.detail.selectedRecord.Id;
            this.template.querySelector('lightning-input[data-my-id=form-input-2]').value=event.detail.selectedRecord.Id;
        }
    }
    updateRecordView(){
        setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
        },1000);
    }
}