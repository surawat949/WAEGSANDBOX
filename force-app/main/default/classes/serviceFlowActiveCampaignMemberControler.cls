public with sharing class serviceFlowActiveCampaignMemberControler {
    @AuraEnabled
    public static List<Account_Campaing_Member__c> getCampaignMemberList(String recordId){
        Case caseRec = [Select Id,AccountId,Account.Hoya_Account_ID__c from Case Where Id=:recordId];
        Date endDate = Date.today().addMonths(-2);
        if(String.isNotBlank(caseRec.AccountId)){
            return [SELECT  Name,id, Central_Campaign__c, Account_Name__c, Campaign_Start_Date_t__c, Campaign_End_Date_t__c, campaign_active__c,
             Central_Campaign__r.name, Campaign_Name__c,Campaign_Presented__c
             FROM Account_Campaing_Member__c /*WHERE Account_Name__r.Hoya_Account_ID__c=:caseRec.Account.Hoya_Account_ID__c AND campaign_active__c=true 
             and Campaign_End_Date_t__c>=:endDate
             order by Campaign_Start_Date_t__c desc, Campaign_End_Date_t__c desc*/];
        }
        return null;
    }
}