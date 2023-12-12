@isTest
public with sharing class SendRegistrationInvite_Controller_Test {
    
    private static final String CONTACT_SHOP_OWNER_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Shop_Owner').getRecordTypeId();
    private static final String CONTACT_SHOP_ASSISTANT_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Shop_Assistant').getRecordTypeId();
	private static final String TEMPLATE_MASTER_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('MasterRT').getRecordTypeId();
    private static final String ACCTEMPLATE_COPY_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
   
    @TestSetup
    static void makeData(){
        Account acc = new Account(
                Name = 'Test Acc',
               Hoya_Account_Id__c = 'FR001234',
              currencyIsoCode='EUR',
              ownerId='0050X0000075o21QAA',          
              Billing_Email_address__c = 'account@email.com'
        );
        insert acc;

        Contact ct = new Contact(
            AccountId = acc.Id,
            FirstName = 'John',
            LastName = 'Contact',
            RecordTypeId = CONTACT_SHOP_ASSISTANT_RT,
            Invite_Portal_Email__c = 'HOYA Hub'
        );
        insert ct;
        Account_Template__c tmp = new Account_Template__c(
        	name = 'Template1',
            RecordTypeId = TEMPLATE_MASTER_RT
        );
        insert tmp;
        
        Account_Template__c atCopy = new Account_Template__c(
            Account__c = acc.Id,
            Master_Template__c = tmp.Id,
            Name = 'Test Acc',
            RecordTypeId = ACCTEMPLATE_COPY_RT
        );
        insert atCopy;
    }

    @isTest
    static void testController() {
        
        
        Contact ct = [SELECT Id, Email, Send_Registration_Email_Flag__c FROM Contact LIMIT 1];
        String result = SendRegistrationInvite_Controller.sendRegistrationInvite(ct.Id);
        system.assertEquals('Contact is not a Shop Owner or is already registered.', result);
        
        ct.RecordTypeId = CONTACT_SHOP_OWNER_RT;
        update ct;
        result = SendRegistrationInvite_Controller.sendRegistrationInvite(ct.Id);
        system.assertEquals('Contact Email is not filled in.', result);
        
        ct = [SELECT Id, Email, Send_Registration_Email_Flag__c,Account_Portal__c,Account_template__c FROM Contact LIMIT 1];
        ct.Email = 'testemail@myemail.com';
        ct.Invite_Portal_Email__c = 'HOYA Hub';
        update ct;
        result = SendRegistrationInvite_Controller.sendRegistrationInvite(ct.Id);
        system.assertEquals('Account Portal or Account Template is not filled in', result);
        
        Account_template__c tmpl = [Select Id, name from Account_template__c where RecordTypeId =: ACCTEMPLATE_COPY_RT Limit 1];
        ct.Account_Template__c = tmpl.Id;
        update ct;
        result = SendRegistrationInvite_Controller.sendRegistrationInvite(ct.Id);
        system.assertEquals('Email was successfully sent to the customer.', result);
        ct = [SELECT Id, Email, Invite_Portal_Email__c FROM Contact LIMIT 1];
        ct.Invite_Portal_Email__c = '';
        update ct;
        result = SendRegistrationInvite_Controller.sendRegistrationInvite(ct.Id);
        
        
      
        ct.Invite_Portal_Email__c = 'HHP Canada';
        update ct;
        ct = [SELECT Id, Email, Invite_Portal_Email__c,Account_portal__c FROM Contact LIMIT 1];
        result = SendRegistrationInvite_Controller.sendRegistrationInvite(ct.Id);
        //system.assertEquals('Email was successfully sent to the customer.', result);*/
    }
}