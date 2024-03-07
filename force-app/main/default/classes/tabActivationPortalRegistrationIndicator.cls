public class tabActivationPortalRegistrationIndicator {
    @AuraEnabled(cacheable=true)
   public static IndicatorWrapper getAIIndicators(Id recordId) {
       IndicatorWrapper wrapper = new IndicatorWrapper();
       String userLanguage = UserInfo.getLanguage();
       DateTime currentDate = DateTime.now();
       Date sixMonthsAgo = Date.valueOf(currentDate.addMonths(-6));
       
       ID subscriptionRecId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Subscription').getRecordTypeId();
       ID shopOwnerRecId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Shop_Owner').getRecordTypeId();

       Account currAcc  = [Select Id,Account_Status__c,Portal__c,Language__c,Brand_Visibility__c,Catalog_name__c,Brand__c,Account_Number_ILog__c,
                          Lenses_Net_Sales_Last_12Mo__c,CHCUSTCLASSIFICATIONID__c
                          From Account WHERE id =: recordId limit 1];
       list<New_Media_Usage__c> listOfNewMedia= [SELECT Id,Tool__c,Transaction_date_field__c 
                                                 FROM New_Media_Usage__c WHERE 
                                                  Hoya_Account_ID__c =:recordId And Transaction_date_field__c>=:sixMonthsAgo
                                                  And (Tool__c ='SXN Orders' OR Tool__c='HoyaiLog orders')];
       List<Contact> listContact = [SELECT ID,AccountId,Subscription_Type__c,
                                    Email,Active_Subscription__c,Sync_to_Pardot__c,RecordTypeId 
                                    FROM Contact WHERE AccountId=: recordId 
                                    AND RecordTypeId=: subscriptionRecId AND Email !='' and Subscription_Type__c = 'Track and Trace' And
                                    Active_Subscription__c =true And Sync_to_Pardot__c = 'Yes'];
       List<Contact> listOfContact1 = [SELECT ID,AccountId,RecordTypeId,Portal_User_Name__c,Send_Registration_Email_Flag__c FROM Contact 
                                     WHERE AccountId=: recordId];
       if (currAcc.Account_Status__c == 'Closed') {
               wrapper.trackTraceFlag = 'GREY'; 
               wrapper.trackTraceFlagMeaning=System.Label.get('', 'Track_Trace_01', userLanguage);
               wrapper.iLogFlag = 'GREY'; 
               wrapper.iLogFlagMeaning=System.Label.get('', 'iLog01', userLanguage);
               wrapper.registrationFlag = 'GREY';   
               wrapper.registrationFlagMeaning=System.Label.get('', 'Registration01', userLanguage);  
               
        }
       else{
           //track flag
           if (listContact.size() > 0) {
               wrapper.trackTraceFlag = 'GREEN';   
               wrapper.trackTraceFlagMeaning=System.Label.get('', 'Track_Trace_02', userLanguage);
               
           } 
           else{
               if(currAcc.Lenses_Net_Sales_Last_12Mo__c>0){
                   if(currAcc.CHCUSTCLASSIFICATIONID__c =='Ind'){
                       wrapper.trackTraceFlag = 'REDALERT';   
                       wrapper.trackTraceFlagMeaning=System.Label.get('', 'Track_Trace_03', userLanguage);
                       
                   } 
                   else{
                       wrapper.trackTraceFlag = 'RED';   
                      
                       wrapper.trackTraceFlagMeaning=System.Label.get('', 'Track_Trace_04', userLanguage);
                       

                   }
               }
               else{
                   wrapper.trackTraceFlag = 'GREEN';   
                   wrapper.trackTraceFlagMeaning=System.Label.get('', 'Track_Trace_05', userLanguage);
                   
               }
           }
           //ilogFlag
           
           Date twoMonthsAgo = Date.valueOf(currentDate.addMonths(-2));
           boolean newMedaiFound=false;    
           system.debug('>>>'+currAcc.Catalog_name__c);       
            if(currAcc.Catalog_name__c !='' && currAcc.Catalog_name__c != null){
                if(currAcc.Brand__c !='' && currAcc.Brand__c != null){
                    if(currAcc.Account_Number_ILog__c !='' && currAcc.Account_Number_ILog__c !=null){
                        if(listOfNewMedia.size()>0){
                            newMedaiFound=true;
                        }
                        else{
                            wrapper.iLogFlag = 'REDALERT'; 
                            system.debug('>>>here1');
                            wrapper.iLogFlagMeaning=System.Label.get('', 'iLog04', userLanguage);       
                        }
                        if(newMedaiFound){
                                for(New_Media_Usage__c newMediaObj : listOfNewMedia){
                                    system.debug('>>>here3');
									if(newMediaObj.Transaction_date_field__c >=twoMonthsAgo && newMediaObj.Transaction_date_field__c !=null &&  newMediaObj.Transaction_date_field__c<= Date.valueOf(currentDate)){
										system.debug('>>>here4');
										wrapper.iLogFlag = 'GREEN';   
										wrapper.iLogFlagMeaning=System.Label.get('', 'iLog02', userLanguage);
										break;
									}
									else{
										wrapper.iLogFlag = 'GREENALERT';   
										wrapper.iLogFlagMeaning=System.Label.get('', 'iLog03', userLanguage);      
									}
                                }      
                        }
                        else{
                            wrapper.iLogFlag = 'REDALERT'; 
                            system.debug('>>>here1');
                            wrapper.iLogFlagMeaning=System.Label.get('', 'iLog04', userLanguage);       
                        }
                    }
                     else{
                       wrapper.iLogFlag = 'RED';   
                       wrapper.iLogFlagMeaning=System.Label.get('', 'iLog05', userLanguage);    
                    }
                   
                }
                else{
                   wrapper.iLogFlag = 'RED';   
                   wrapper.iLogFlagMeaning=System.Label.get('', 'iLog06', userLanguage); 
                }
            }    
            else{
             wrapper.iLogFlag = 'RED';   
             wrapper.iLogFlagMeaning=System.Label.get('', 'iLog07', userLanguage);  
            }
            //Registration flag is start 
            Boolean showElsePart=false;
            for(Contact con : listOfContact1){
                if(con.RecordtypeId==shopOwnerRecId && con.Portal_User_Name__c!=null && con.Portal_User_Name__c!=''){
                        showElsePart=true;
                        break;
				}	
            }				
            if(showElsePart){    
					if(currAcc.Portal__c!='' && currAcc.Portal__c !=null){
                      	if(currAcc.Language__c!='' && currAcc.Language__c !=null){  
                            if(currAcc.Brand_Visibility__c!='' && currAcc.Brand_Visibility__c !=null){
                                wrapper.registrationFlag = 'GREEN';   
                                wrapper.registrationFlagMeaning=System.Label.get('', 'Registration02', userLanguage); 
                            }								
                            else{
                                wrapper.registrationFlag = 'REDALERT';   
                                wrapper.registrationFlagMeaning=System.Label.get('', 'Registration03', userLanguage);    
                            } 
                        }
                        else{
                            wrapper.registrationFlag = 'REDALERT';   
                            wrapper.registrationFlagMeaning=System.Label.get('', 'Registration04', userLanguage);     
                        } 
                    }    
                    else{
                        wrapper.registrationFlag = 'REDALERT';   
                        wrapper.registrationFlagMeaning=System.Label.get('', 'Registration05', userLanguage);     
                    }
            }
            else{
                if(currAcc.Portal__c!='' && currAcc.Portal__c !=null){
                    if(currAcc.Language__c!='' && currAcc.Language__c !=null){
                        if(currAcc.Brand_Visibility__c!='' && currAcc.Brand_Visibility__c !=null){
                            if(listOfContact1.size()>0){
                               for(Contact con : listOfContact1){
                                   if(con.RecordtypeId==shopOwnerRecId && con.Send_Registration_Email_Flag__c==true){
                                       wrapper.registrationFlag = 'REDALERT';   
                                       wrapper.registrationFlagMeaning=System.Label.get('', 'Registration06', userLanguage);
                                       break;
                                   }
                                    else{
                                       wrapper.registrationFlag = 'RED';   
                                       wrapper.registrationFlagMeaning=System.Label.get('', 'Registration07', userLanguage);
                                    }    
                                }   
                            }
                            else{
                               wrapper.registrationFlag = 'RED';   
                               wrapper.registrationFlagMeaning=System.Label.get('', 'Registration07', userLanguage);        
                            }
                        }
                        else{
                           wrapper.registrationFlag = 'RED';   
                           wrapper.registrationFlagMeaning=System.Label.get('', 'Registration08', userLanguage);     
                        }
                    }
                    else{
                        wrapper.registrationFlag = 'RED';   
                        wrapper.registrationFlagMeaning=System.Label.get('', 'Registration09', userLanguage); 
                    }
                }
                else{
                   wrapper.registrationFlag = 'RED';   
                   wrapper.registrationFlagMeaning=System.Label.get('', 'Registration10', userLanguage);  
                }
            }
           
        }
       
       return wrapper;
    }
   public class IndicatorWrapper {
       @AuraEnabled public String trackTraceFlag{get;set;}
       @AuraEnabled public String trackTraceFlagMeaning{get;set;}
       @AuraEnabled public String iLogFlag{get;set;}
       @AuraEnabled public String iLogFlagMeaning{get;set;}
       @AuraEnabled public String registrationFlag{get;set;}
       @AuraEnabled public String registrationFlagMeaning{get;set;}
       
      
   }
   

}