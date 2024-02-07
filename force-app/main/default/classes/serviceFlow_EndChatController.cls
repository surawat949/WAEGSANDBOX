/**
 * @description       : 
 * @author            : Fazurulla Ganganapali
 * @group             : 
 * @last modified on  : 
 * @last modified by  : Fazurulla Ganganapali
**/
public class serviceFlow_EndChatController {
    @AuraEnabled
    public static serviceFlowAgentNavWrapper getUserData(string recTypeName, string accId) {
        try {
            serviceFlowAgentNavWrapper returnWrapper = New serviceFlowAgentNavWrapper();
            User userObj = [Select Id, Name, UserName, Country__c, Country_for_Customer_Support__c 
                            FROM User WHERE Id = :userInfo.getUserId()];
            Account accObj = null;
            if(String.isNotBlank(accId)){               
                accObj = [SELECT Id, Name, Shop_email_address__c, Phone,Brand__c
                                  FROM Account WHERE Id = :accId];
            }
            returnWrapper.UserData = userObj;
            returnWrapper.accountData = accObj;
            
            if(String.isNotBlank(userObj.Country_for_Customer_Support__c))
            returnWrapper.recordTypeId = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
            system.debug('returnWrapper -- '+returnWrapper);
            return returnWrapper;
        } catch (Exception ex) {
            System.debug(ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static string createCaseRecord(string caseDetails) {
        string caseRecId = '';
        try {
            if(String.isNotBlank(caseDetails)) {
                system.debug('caseDetails-- '+caseDetails);
                Case caseRec = (Case)JSON.deserialize(caseDetails, Case.class);
                if(caseRec != NULL){
                    insert caseRec;
                    caseRecId = caseRec.Id;
                }
            }
            return caseRecId;
        } catch (Exception ex) {
            System.debug(ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }

    public class serviceFlowAgentNavWrapper{
        @AuraEnabled
        public User UserData{set;get;}
        @AuraEnabled
        public string recordTypeId{set;get;}
        @AuraEnabled
        public Account accountData{set;get;}
    }
}