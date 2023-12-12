public class TabVisitsIndicatorController {
    @AuraEnabled(cacheable=true)
    public static IndicatorWrapper getAIIndicators(Id receivedId) {
       Account currAcc  = [Select Id,Account_Status__c,Potential__c,Lenses_Net_Sales_LFY__c,Segmentation_Box__c,
                          Total_Visits_Planned__c,Visits_performed__c,Digital_Visits_Performed__c,Language__c,
                           Lenses_Net_Sales_Last_12Mo__c,Last_Visit_date__c,TACTICOM_SOF__c,
                          Strategic_Value_Gross_Sales__c,Strategic_Value_Net_Sales__c,Hoya_Account_ID__c,Owner.CompanyName
                          From Account WHERE id =: receivedId limit 1];
        List<Last_Sales_Statistics__c> statsList = [Select Id, Lenses_Net_Sales_Last_12Mo__c, Lenses_Gross_Sales_Last_12Mo__c,
                                                    Lenses_Net_Sales_LFY__c,Lenses_Gross_Sales_LFY__c
                                                    From Last_Sales_Statistics__c Where  Account__c = :receivedId];
        List<Account_Campaing_Member__c> listAccountCampaingMember = [SELECT ID,campaign_active__c,Campaign_Presented__c,
                                                                      Campaign_End_Date_t__c FROM Account_Campaing_Member__c 
                                                                      WHERE Account_Name__c=:receivedId
                                                                     ];
        List<Contact> listContact = [SELECT ID,AccountId,ShowpadForSF__Showpad_Last_Activity_Date__c,
                                    ShowpadForSF__Showpad_Last_View_Date__c FROM Contact WHERE AccountId=: receivedId];
        List<Identified_Business_Opportunity__c> lstBusiOpp = [SELECT Id, Account__c, Project_Status__c 
                                                               FROM Identified_Business_Opportunity__c 
                                                               WHERE Account__c = :receivedId AND Project_Status__c IN('Not Started','In progress','Posponed') ];
        
        List<Visits__c> listOfVisit = [SELECT ID,Visit_Type__c,Visit_Status__c FROM Visits__c 
                                       WHERE Account__c = :receivedId AND Visit_Type__c ='Visit'];
        IndicatorWrapper wrapper = new IndicatorWrapper();
        if(currAcc !=null){
            if(currAcc.Account_Status__c == 'Closed'){
            	wrapper.flagTotalVisits='GREY';  
                wrapper.strategicValueIndicator='GREY';
                wrapper.busiOppIndicator='GREY';
                wrapper.campaignsIndicator='GREY';
                wrapper.showpadIndicator='GREY';
                wrapper.lifeCycleFlag='GREY';
                if(currAcc.TACTICOM_SOF__c == '' || currAcc.TACTICOM_SOF__c == null){
                        wrapper.tacticomFlag = 'GREY';
                }
                else{
                 	   wrapper.tacticomFlag = 'GREYALERT';   
                }

                
            }
            else{
                //total visit flag                
                system.debug('>>>>');
                 wrapper.tacticomFlag = 'GREY';
                wrapper.lifeCycleFlag='GREY';
                if(currAcc.Total_Visits_Planned__c>0){
                    system.debug('>>>>1');
                    system.debug('>>>currAcc.Visits_performed__c'+currAcc.Visits_performed__c +'>>>Digital_Visits_Performed__c'+currAcc.Digital_Visits_Performed__c);
                    if(currAcc.Visits_performed__c+currAcc.Digital_Visits_Performed__c>0){
                        system.debug('>>>>2');
                        
                        if(Math.abs(currAcc.Total_Visits_Planned__c - (currAcc.Visits_performed__c+currAcc.Digital_Visits_Performed__c))<=1){
                            wrapper.flagTotalVisits='GREEN';
                            system.debug('>>>>3');
                        }   
                        else if(Math.abs(currAcc.Total_Visits_Planned__c - (currAcc.Visits_performed__c+currAcc.Digital_Visits_Performed__c))<=2){
                            system.debug('>>>>4');
                            wrapper.flagTotalVisits='GREENALERT';    
                        }
                        else if(Math.abs(currAcc.Total_Visits_Planned__c - (currAcc.Visits_performed__c+currAcc.Digital_Visits_Performed__c))<=3){
                            system.debug('>>>>5');
                            wrapper.flagTotalVisits='RED';
                        }
                        else{
                            system.debug('>>>>6');
                            wrapper.flagTotalVisits='REDALERT';  
                        }
                    }
                    else{
                        system.debug('>>>>7');
                        wrapper.flagTotalVisits='REDALERT';
                    }
                }
                else if(currAcc.Visits_performed__c + currAcc.Digital_Visits_Performed__c >0){
                    wrapper.flagTotalVisits='RED';        
                }
                else{
                    wrapper.flagTotalVisits='GREEN';      
                }
             // StrategicValueIndicator 
                if(statsList.size()>0){
                    system.debug('>>>currAcc'+currAcc.Hoya_Account_ID__c);
                    if(statsList[0].Lenses_Net_Sales_Last_12Mo__c>0 || statsList[0].Lenses_Net_Sales_LFY__c>0){
                        if(currAcc.Hoya_Account_ID__c.startsWith('SO4900') || currAcc.Hoya_Account_ID__c.startsWith('SO4990') || 
                            currAcc.Owner.CompanyName == 'HODG'){
                               system.debug('>>>'+currAcc.Strategic_Value_Gross_Sales__c);
                            if(currAcc.Strategic_Value_Gross_Sales__c == 0 || currAcc.Strategic_Value_Gross_Sales__c==null){
                               system.debug('>>>1');
                               wrapper.strategicValueIndicator='RED'; 
                            }
                            else if(currAcc.Strategic_Value_Gross_Sales__c<statsList[0].Lenses_Gross_Sales_LFY__c){
                                wrapper.strategicValueIndicator='REDALERT';    
                            }
                            else if(currAcc.Strategic_Value_Gross_Sales__c<statsList[0].Lenses_Gross_Sales_Last_12Mo__c){
                                wrapper.strategicValueIndicator='REDALERT';     
                            }
                            else{ wrapper.strategicValueIndicator='GREEN'; }
                           
                        }
                        
                        else if(currAcc.Strategic_Value_Net_Sales__c==0 || currAcc.Strategic_Value_Net_Sales__c==null){
                            wrapper.strategicValueIndicator='RED';      
                        }
                        else if(currAcc.Strategic_Value_Net_Sales__c < statsList[0].Lenses_Net_Sales_LFY__c){
                            wrapper.strategicValueIndicator='REDALERT';     
                        }
                        else if(currAcc.Strategic_Value_Net_Sales__c < statsList[0].Lenses_Net_Sales_Last_12Mo__c){
                            wrapper.strategicValueIndicator='REDALERT';     
                        }
                        else{
                           wrapper.strategicValueIndicator='GREEN';  
                        }
                    }
                    else{
                        system.debug('>>testclass'+currAcc.Hoya_Account_ID__c);
                         if(currAcc.Hoya_Account_ID__c.startsWith('SO4900') || currAcc.Hoya_Account_ID__c.startsWith('SO4990') || 
                            currAcc.Owner.CompanyName == 'HODG'){
                                if(currAcc.Strategic_Value_Gross_Sales__c == 0 || currAcc.Strategic_Value_Gross_Sales__c ==null){
                                	wrapper.strategicValueIndicator='REDALERT';      
                                }
                                else{
                                   wrapper.strategicValueIndicator='GREEN';   
                                }
                         }
                        else if(currAcc.Strategic_Value_Net_Sales__c == 0 || currAcc.Strategic_Value_Net_Sales__c ==null){
                         	wrapper.strategicValueIndicator='REDALERT';     
                        }
                        else{
                            wrapper.strategicValueIndicator='GREEN';  
                        }
                    }
                }   
                else{
                    wrapper.strategicValueIndicator='REDALERT';    
                }
                //business Opportunities flag
                system.debug('>>>>'+currAcc.Segmentation_Box__c);
                if(lstBusiOpp.size()>0){
                 	wrapper.busiOppIndicator='GREEN';   
                }
                else if(currAcc.Segmentation_Box__c=='A1' || currAcc.Segmentation_Box__c=='A2'||
                    currAcc.Segmentation_Box__c=='B1' ||  currAcc.Segmentation_Box__c=='B2' || 
                    currAcc.Segmentation_Box__c=='C1' || currAcc.Segmentation_Box__c=='C2'){
                       system.debug('>>>>111');
                    wrapper.busiOppIndicator='RED';    
                }
                else if(currAcc.Visits_performed__c>0){
                    if(currAcc.Visits_performed__c>2){
                      wrapper.busiOppIndicator='REDALERT';     
                    }
                    else{
                       wrapper.busiOppIndicator='RED';        
                    }
                     
                }
                else if(currAcc.Total_Visits_Planned__c>0){
                    wrapper.busiOppIndicator='GREYALERT'; 
                }
                else{
                    wrapper.busiOppIndicator='GREY';    
                }
                //business Opportunities flag ends
                //Campaigns flag start
                if(listAccountCampaingMember.size()>0){ 
                    system.debug('>>>>');
                    for(Account_Campaing_Member__c accountCampaingMember : listAccountCampaingMember){
                        if(accountCampaingMember.campaign_active__c == true && 
                           accountCampaingMember.Campaign_Presented__c ==false ){
                               system.debug('>>>>>');
                               system.debug('>>>>>2'+System.today().daysBetween(accountCampaingMember.Campaign_End_Date_t__c));
                                system.debug('>>>>>1'+accountCampaingMember.Campaign_End_Date_t__c.daysBetween(System.today()));
                            if(accountCampaingMember.Campaign_End_Date_t__c>=System.Today()){
                                system.debug('>>>>>'+accountCampaingMember.Campaign_End_Date_t__c);
                                system.debug('>>>>>'+accountCampaingMember.Campaign_End_Date_t__c.daysBetween(System.today()));
                                if(System.today().daysBetween(accountCampaingMember.Campaign_End_Date_t__c)<=15){
                                    wrapper.campaignsIndicator='REDALERT';
                                }  	   
                                else{
                                    wrapper.campaignsIndicator='RED';    
                                }
                            }
                            else{
                                wrapper.campaignsIndicator='GREYALERT';  
                            }
                        }    
                        else if(accountCampaingMember.campaign_active__c == false && 
                            accountCampaingMember.Campaign_Presented__c ==false &&
                            accountCampaingMember.Campaign_End_Date_t__c<system.Today()){
                            system.debug('>>>>1'+accountCampaingMember.Campaign_End_Date_t__c.monthsBetween(system.today()));

                                if(accountCampaingMember.Campaign_End_Date_t__c.monthsBetween(system.today())<=3){
                                    wrapper.campaignsIndicator='GREENALERT';     
                                }
                                else{
                                    wrapper.campaignsIndicator='GREEN';    
                                }
                         }
                         else{
                          	wrapper.campaignsIndicator='GREEN';   
                        }
                    }
                } 
                else{
                        wrapper.campaignsIndicator='GREEN';   
                }
                //Campaigns flag start ends
                //tacticom flag start
                String tacticomFlag = tecticomIndicators(receivedId,currAcc.Segmentation_Box__c,currAcc.TACTICOM_SOF__c);
                system.debug('>>>tacticomFlag'+tacticomFlag);
                wrapper.tacticomFlag = tacticomFlag; 
            }
        }
        system.debug('>>>>wrapper'+wrapper);
        return wrapper;
}   
     public class IndicatorWrapper {
        @AuraEnabled public String flagTotalVisits{get;set;}
        @AuraEnabled public String strategicValueIndicator{get;set;}
        @AuraEnabled public String busiOppIndicator{get;set;}
        @AuraEnabled public String campaignsIndicator{get;set;}
        @AuraEnabled public String showpadIndicator{get;set;}
        @AuraEnabled public String tacticomFlag{get;set;}
        @AuraEnabled public String lifeCycleFlag{get;set;} 
    }
    public static String tecticomIndicators(Id receivedId,String Segment,String subArea) {
        list<Visits__c> listOfVisit60days = [SELECT ID,Visit_Type__c,Visit_Status__c FROM Visits__c 
                                            WHERE Account__c =:receivedId AND Visit_Type__c ='Visit' AND Visit_Status__c ='Planned' AND  Start_Time__c >today AND Start_Time__c <= NEXT_N_DAYS:60 limit 1];
                                              
        list<Visits__c> listOfVisit90days = [SELECT ID,Visit_Type__c,Visit_Status__c,Start_Time__c FROM Visits__c 
                                            WHERE Account__c =:receivedId AND Visit_Type__c ='Visit' AND Visit_Status__c ='Complete' AND  Start_Time__c <today AND Start_Time__c >= LAST_N_DAYS:90 limit 1];
        
        list<Visits__c> listOfVisit180days =[SELECT ID,Visit_Type__c,Visit_Status__c,Start_Time__c FROM Visits__c 
                                            WHERE Account__c =:receivedId AND Visit_Type__c ='Visit' AND Visit_Status__c ='Complete' AND  Start_Time__c <today AND Start_Time__c >= LAST_N_DAYS:180 limit 1];
        string tecticomFlag;
        system.debug('>>>1'+listOfVisit180days+ '>>>2'+listOfVisit90days +'>>>3'+listOfVisit60days);
        system.debug('>>subArea'+subArea);
        if(subArea != '' && subArea != null && subArea != 'None'){
            if(listOfVisit180days.size()>0){
                if(listOfVisit90days.size()>0){
                    system.debug('>>>1');
                    tecticomFlag='GREEN';   
                }
                else if(listOfVisit60days.size()>0){
                    system.debug('>>>2');
                    tecticomFlag='GREEN';
                }
                else{
                    system.debug('>>>3');
                    tecticomFlag='GREENALERT'; 
                }
            }else if(listOfVisit60days.size()>0){
                system.debug('>>>2');
                tecticomFlag='GREEN';
            }
            else{
                system.debug('>>>3');
                tecticomFlag='RED'; 
            }
        }  
        else if(listOfVisit90days.size()>0){
            system.debug('>>>4');
            if(listOfVisit60days.size()>0){
                system.debug('>>>5');
             	tecticomFlag = 'RED';    
            }else if(Segment=='A1' || Segment=='A2'||
                Segment=='B1' ||  Segment=='B2' || 
                Segment=='C1' || Segment=='C2'){
                    system.debug('>>>6');
                tecticomFlag = 'REDALERT';                   
            } 
            else{
             	tecticomFlag = 'GREENALERT';   
            }
        }
        else if(listOfVisit180days.size()>0){
            if(listOfVisit60days.size()>0){
            	tecticomFlag = 'RED';     
            }
            else if(Segment=='A1' || Segment=='A2'||
                Segment=='B1' ||  Segment=='B2' || 
                Segment=='C1' || Segment=='C2'){
                tecticomFlag = 'REDALERT';                   
            } 
            else{
                system.debug('>>>7');
             	tecticomFlag = 'GREEN';   
            }
        }
        else if(listOfVisit60days.size()>0){
            tecticomFlag = 'RED';    
        }
        else{
         	tecticomFlag = 'GREEN';    
        }
        return tecticomFlag;
    }
}