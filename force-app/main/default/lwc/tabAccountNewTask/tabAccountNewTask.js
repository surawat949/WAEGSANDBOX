import { LightningElement,api,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import Support_Img from "@salesforce/resourceUrl/Get_Support";
import { encodeDefaultFieldValues } from "lightning/pageReferenceUtils";
import getRecordTypeId from '@salesforce/apex/TabAccountNewTaskLWCController.taskRecordTypeId';




export default class TabAccountNewTask extends NavigationMixin(LightningElement) {
    // Navigate to New Account Page
    @api recordId;
    recordTypeId;
    SupportImg = Support_Img;

    @wire(getRecordTypeId)
        wiredGetRecordType({ error, data }) {
            console.log('>>>',data);

            if (data) {
                this.recordTypeId = data;
                console.log('>>>recordtype',this.recordTypeId);
            }
            
        }

    navigateToNewTaskPage() {
        console.log('>>record',this.recordTypeId);
        const defaultValues = encodeDefaultFieldValues({
            WhatId : this.recordId,
            RecordTypeId : this.recordTypeId,

           
         });
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Task',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues,
            }
        });
    }
}