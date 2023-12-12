/*
     * @Author : Mohan Krishna
     * @Class name : UserLogic_Test
     * Created date : 2023-04-20
     * Updated date : 
     * @Created by : Mohan Krishna
     * @Description : Test class for UserLogic.cls apex class
 */

@isTest
public class UserLogic_Test {
    
  
    @TestSetup
    public static void makeData(){

        String RecTypeId = [select Id, Name from RecordType where sObjectType='Contact' and DeveloperName='Shop_Owner'].Id;
        String MasterTempId = [select Id, Name from RecordType where sObjectType='Account_Template__c' and Name='Master'].Id;
        String CopyTempId = [select Id, Name from RecordType where sObjectType='Account_Template__c' and DeveloperName='Copy'].Id;

        Account_Template__c master = new Account_Template__c();
        master.RecordTypeId = MasterTempId;
        master.Name = 'HOLK-Test-master';
        insert master;

        Account a = new Account();
        a.Hoya_Account_Id__c = 'SK1112';
        a.Name = 'Test-sk';
        a.CurrencyIsoCode = 'EUR';
        a.Portal__c='beseikoportal';
        insert a;

        Account a1 = new Account();
        a1.Hoya_Account_Id__c = 'SK1113';
        a1.Name = 'Test-sk2';
        a1.currencyisocode = 'EUR';
        insert a1;

        Account_Template__c copy = new Account_Template__c();
        copy.Name = 'holk-test-copy';
        copy.Account__c = a.Id;
        copy.Default__c = true;
        copy.Master_Template__c = master.Id;
        copy.Active_Authorization_Template__c = true;
        copy.RecordTypeId = CopyTempId;
        insert copy;

        Contact c = new Contact();
        c.FirstName = 'testh';
        c.LastName = 'lasth';
        c.Account_Template__c = copy.Id;
        c.AccountId = a.Id;
        c.Email = 'test@hotmail.com';
        c.Created_on_portal__c=true;
        c.Invite_Portal_Email__c='	VI, HLC, Hoya Hub';
        c.Language_Pick__c='en-us';
       // c.Account_Portal__c='Seiko Pro';
        c.RecordTypeId = RecTypeId;
        insert c;

        Profile p = [select Id from Profile where Name = 'Customer Community Plus User' limit 1];
       // Profile license = [select Id from profile where profile.userlicense.name = 'Customer Community Plus' limit 1];

        User u = new User();
        u.FirstName = 'Testcommunity1';
        u.LastName = 'Testlastcomm1';
        u.Email = 'testyyy@gmail.com.invalid';
        u.UserName = 'testyyy@tradeportal.hoya.com.waeg';
        u.profileid = p.Id;
        u.LocaleSidkey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.CompanyName = 'HVC';
        u.Alias = 'testzxcv';
        u.EmailEncodingKey = 'UTF-8';
        u.ContactId = c.Id;
        u.Reset_Password_Token__c='KJWHE7346873';
        insert u;

 	    System.debug('User-->99'+u);

    }

    
    @isTest
    public static void sendEmailHandlerTest(){
        
        Contact c=[Select id,Created_on_portal__c,Account.name,Account.Portal__c,Contact_Record_Type__c,Legacy_Account_Number__c,Account_Template__c,Account_Portal__c,Invite_Portal_Email__c from contact where FirstName = 'testh'];
        System.debug('Contact Details-->'+c);
        
        List<User> newList=[SELECT Id, Profile.Name, Reset_Password_Token__c, 
                            Reset_Password_Context__c, Username, ContactId, Contact.Id, 
                            Contact.Created_on_portal__c, Contact.Contact_Record_Type__c, 
                            Contact.Account_Template__c, Contact.Account_Portal__c, 
                            Contact.Invite_Portal_Email__c, Contact.Legacy_Account_Number__c, 
                            Contact_Language__c FROM User WHERE ContactId =: c.Id];
       
       System.debug('newLIST-->'+newList);
       
       Map<Id, User> oldObjectsMap=new  Map<Id, User>([Select Id,Profile.Name,Reset_Password_Token__c,Reset_Password_Context__c, Username, ContactId,
                            Contact.Created_on_portal__c,Contact.Contact_Record_Type__c, Contact.Account_Template__c,
                            Contact.Account_Portal__c, Contact.Invite_Portal_Email__c, Contact_Language__c from user where UserName='testyyy@tradeportal.hoya.com.waeg']);

       Test.startTest();
          UserLogic.sendEmailHandler(newList,oldObjectsMap);
       Test.stopTest();
    }

}