import { LightningElement ,api,wire} from 'lwc';
//apex
import getIndicators from '@salesforce/apex/tabAIIndicatorsController.getAIIndicators';
//Static Resources
import AI_Indicators from '@salesforce/resourceUrl/SFDC_V2_AI_Indicators';
export default class TabStatisticsIndicators extends LightningElement {
    @api receivedId;
    salesIndicator;
    competitorIndicator;
    strategicIndicator;
    deliveryIndicator;
    returnsIndicator;
    commitmentsIndicator;
    returnsFlagMeaning;
    salesFlagMeaning;
    deliveriesFlagMeaning;
    competitorFlagMeaning;
    strategicValFlagMeaning;
    commitmentsFlagMeaning;

    
    @wire(getIndicators, {receivedId: '$receivedId',tabName:'Statistics'}) 
     getIndicators ({error, data}) {
        if(data){
            console.log(data);
            // Set the variable value here based on apex response.
            this.salesIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.salesFlag);
            this.competitorIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.competitorFlag);
            this.commitmentsIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.commitmentsFlag);
            this.deliveryIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.deliveriesFlag);
            this.returnsIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.returnsFlag);
            this.strategicIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.strategicValFlag);
            this.salesFlagMeaning = data.salesFlagMeaning;
            this.commitmentsFlagMeaning = data.commitmentsFlagMeaning;
            this.returnsFlagMeaning = data.returnsFlagMeaning;
            this.deliveriesFlagMeaning= data.deliveriesFlagMeaning;
            this.competitorFlagMeaning= data.competitorFlagMeaning;
            this.strategicValFlagMeaning = data.strategicValFlagMeaning;
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