public with sharing class tabMVCContactController {
    
    private static final String ACCOUNT_CLINIC_RT = Schema.SObjectType.ACCOUNT.getRecordTypeInfosByDeveloperName().get('Clinic').getRecordTypeId();
    
     //Took code from ContactRelatedClinicsController as part of Azure 701
    @AuraEnabled
    public static List<AccountContactRelation> getRelatedClinicsByContactId(Id contactId){
            List<AccountContactRelation> acList = [select id, contact.Id, Contact.name, Preferred_contact_day_time__c, Account.name, Account.id, Account.brand__c, AccountId, 
                Account.shippingStreet,Account.Clinic_Name__c,Account.shippingPostalCode, Account.shippingCity, Account.Seiko_Network__c, 
                isdirect, Preferred_place_for_visit__c, Contact_role__c,Activity_Phone__c,Working_Status__c   
                from AccountContactRelation where contactId =:contactId AND Account.RecordTypeId=:ACCOUNT_CLINIC_RT AND IsActive = true];
            return acList;
    } 
 
}