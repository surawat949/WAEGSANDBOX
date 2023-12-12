public with sharing class TabMVAActivationContactController {

    /*
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsRelatedAccount(String receivedId){
        List<Contact> conList = [SELECT Id, Name, Contact_Record_Type__c, Salutation, Title, Email, Phone 
                                    FROM Contact WHERE AccountId=:receivedId ORDER BY Name ASC LIMIT 5];
        System.debug('Get Contacts Related to Account == > '+conList);
        return conList;
    }
    */
    private static final string CONTACT_OPTHO_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();
    
    @AuraEnabled(cacheable=true)
    public static List<ContactDetail> getAllContactsHierarchy(String recordId){
        try {
            Set<Id> finalSetId = new Set<Id>();
            Set<Id> accountIdSet = new Set<Id>();
            List<ContactDetail> conDetails = new List<ContactDetail>();
            finalSetId.add(recordId);
            accountIdSet.add(recordId);
            finalSetId.addAll(getRecursiveAccountList(accountIdSet));

            List<AccountContactRelation> relationList = [select Id, AccountId, ContactId, Contact.Name, Account.Name, 
                                                    Account.ShippingCity, Account.ShippingState, Account.ShippingStreet,
                                                    Account.Phone, Preferred_place_for_visit__c,
                                                    Contact_Role__c from AccountContactRelation 
                                                    where AccountId IN: finalSetId and Contact.recordTypeId =:CONTACT_OPTHO_RT
                                                    and IsActive=true order by contact.name asc];
            for(AccountContactRelation eachCon : relationList){
                ContactDetail c = new ContactDetail();
                c.ContactId = eachCon.ContactId;
                c.ContactName = eachCon.Contact.Name;
                c.AccountId = eachCon.AccountId;
                c.AccountName = eachCon.Account.Name;
                c.Street = eachCon.Account.ShippingStreet;

                if(eachCon.Preferred_place_for_visit__c){
                    c.PreferedPlace = 'V';
                }else{
                    c.PreferedPlace = '';
                }

                c.City = eachCon.Account.ShippingCity;
                c.State = eachCon.Account.ShippingState;
                c.Phone = eachCon.Account.Phone;
                c.Role = eachCon.Contact_Role__c;
                conDetails.add(c);

            }
            System.debug('XXx Get Account/Contact Relationship = >'+conDetails.size()+' record(s) ==>'+conDetails);
            return conDetails;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**-- Get all children pass thru account id set */
    @TestVisible
    private static set<Id> getRecursiveAccountList(Set<Id> accIdset){
        List<Account> tmp = [select Id, hoya_account_id__c, name, shop_name__c, parentId from account where parentId IN:accIdset];
        Set<Id> result = new Set<Id>();
        if(tmp != null && tmp.size()>0){
            for(Account acc : tmp){
                result.add(acc.Id);
            }
            result.addAll(getRecursiveAccountList(result));
        }
        return result;
    }

    public class ContactDetail{
        @AuraEnabled public string ContactId{get;set;}
        @AuraEnabled public string ContactName{get;set;}
        @AuraEnabled public string AccountId{get;set;}
        @AuraEnabled public string AccountName{get;set;}
        @AuraEnabled public string Street{get;set;}
        @AuraEnabled public string City{get;set;}
        @AuraEnabled public string Phone{get;set;}
        @AuraEnabled public string State{get;set;}
        @AuraEnabled public string PreferedPlace{get;set;}
        @AuraEnabled public string Role{get;set;}

    }

}