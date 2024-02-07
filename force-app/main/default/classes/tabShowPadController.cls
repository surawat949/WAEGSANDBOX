public with sharing class tabShowPadController {
    public tabShowPadController() {}

    @AuraEnabled(cacheable=true)
    public static IndicatorWrapper getAIIndicators(Id recordId) {
        IndicatorWrapper wrapper = new IndicatorWrapper();
        wrapper.openingFlag = 'GREY';
        wrapper.presenatationFlag = 'GREY';
        
        Account currAcc  = [Select Id,Account_Status__c,Potential__c,Lenses_Net_Sales_LFY__c,Segmentation_Box__c,
                          Total_Visits_Planned__c,Visits_performed__c,Digital_Visits_Performed__c,Language__c,
                           Lenses_Net_Sales_Last_12Mo__c,Last_Visit_date__c,
                          Strategic_Value_Gross_Sales__c,Strategic_Value_Net_Sales__c,Hoya_Account_ID__c,Owner.CompanyName
                          From Account WHERE id =: recordId limit 1];

        List<Contact> listContact = [SELECT ID,AccountId,ShowpadForSF__Showpad_Last_Activity_Date__c, ShowpadForSF__Showpad_Last_View_Date__c FROM Contact WHERE AccountId=: recordId];
         
        //Showpad sharing flag start
        if (currAcc != null) {
            DateTime currentDate = DateTime.now();
            // Calculate the date 3 months ago from the current date
            DateTime threeMonthsAgo = currentDate.addMonths(-3);
            // Calculate the date 12 months ago from the current date
            DateTime twelveMonthsAgo = currentDate.addMonths(-12);
            // Calculate the date 6 months ago from the current date
            DateTime sixMonthsAgo = currentDate.addMonths(-6);
            if (currAcc.Account_Status__c == 'Closed') {
                wrapper.sharingFlag = 'GREY';  	
                wrapper.viewingFlag = 'GREY';
            } else{
                    if (listContact.size() > 0) {
                        Boolean activityFound = false;
                        for (Contact con : listContact) {
                            if(con.ShowpadForSF__Showpad_Last_Activity_Date__c != null && con.ShowpadForSF__Showpad_Last_Activity_Date__c >= sixMonthsAgo && con.ShowpadForSF__Showpad_Last_Activity_Date__c <= currentDate) {
                                activityFound = true;
                                wrapper.viewingFlag = 'GREENALERT';
                                wrapper.sharingFlag = 'GREEN'; 
                                break;
                            }  
                            else{
                                wrapper.sharingFlag = 'RED';     
                                wrapper.viewingFlag = 'RED';								
                                
                            }
                        }
                        if (activityFound) {
                            // check if for any of the contacts we have last view date as expected
                            for (Contact con : listContact) {
                                if (con.ShowpadForSF__Showpad_Last_View_Date__c != null && con.ShowpadForSF__Showpad_Last_View_Date__c >= threeMonthsAgo && con.ShowpadForSF__Showpad_Last_View_Date__c <= currentDate) {
                                    
                                    wrapper.sharingFlag = 'GREEN';
                                    wrapper.viewingFlag = 'GREENALERT';
                                    break; 
                                }
                                else{
                                   wrapper.sharingFlag = 'GREENALERT';
                                   wrapper.viewingFlag = 'GREEN';  
                                }
                            }
                        }

                    } else {
                        wrapper.sharingFlag = 'RED';  
                        wrapper.viewingFlag = 'RED';						
                    }  
		    }			
               
        }      
        // end showpad flag
        return wrapper;
    }

    public class IndicatorWrapper {
        @AuraEnabled public String presenatationFlag{get;set;}
        @AuraEnabled public String sharingFlag{get;set;}
        @AuraEnabled public String openingFlag{get;set;}
         @AuraEnabled public String viewingFlag{get;set;}
    }
}