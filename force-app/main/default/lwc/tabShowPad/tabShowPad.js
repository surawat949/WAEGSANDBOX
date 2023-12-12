import { LightningElement,api ,wire } from 'lwc';
//Apex
import getIndicators from '@salesforce/apex/tabShowPadController.getAIIndicators';
//Static Resources
import AI_Indicators from '@salesforce/resourceUrl/SFDC_V2_AI_Indicators';
export default class TabShowPad extends LightningElement {
    @api recordId;
    presentationIndicator;
    sharingIndicator;
    openingIndicator;
    viewingIndicator;
    @wire(getIndicators, {recordId: '$recordId'}) 
     getIndicators ({error, data}) {
        if(data){
            console.log(data);
            // Set the variable value here based on apex response.
            this.presentationIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.presenatationFlag);
            this.sharingIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.sharingFlag);
            this.openingIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.openingFlag);
            this.viewingIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.viewingFlag);
            
          
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
}