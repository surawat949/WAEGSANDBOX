@IsTest
public class tabActivationPortalRegistIndicaTest {
     @TestSetup
      static void makeData(){
        list<Account> listOfAccount = new list<Account>();
        Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'SO4900TEST001';
        a1.Name = 'Test Account';
        a1.Shop_Name__c = 'Test Account';
        a1.Lenses_Net_Sales_Last_12Mo__c =1;
        a1.Catalog_name__c='test'; 
        a1.Account_Number_ILog__c='1';   
        a1.Portal__c ='usportal';  
        a1.Language__c='en-us'; 
        a1.Brand_Visibility__c='HOYA';
        listOfAccount.add(a1);
        //insert a1;
        Account acc2 = new Account(
            Name = 'Test AccTESR',
            Hoya_Account_ID__c = 'TE-012355',
            phone='0103030408',
           Lenses_Net_Sales_Last_12Mo__c =1,
            Account_Status__c='Closed'
            
        );
        listOfAccount.add(acc2);
        insert listOfAccount;  
       ID subscriptionRecId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Subscription').getRecordTypeId();
       ID shopownerRecId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Shop_Owner').getRecordTypeId();

        list<Contact> listOfContact = new list<Contact>();
        Contact c1 = new Contact();
        c1.AccountId = a1.Id;
        c1.FirstName = 'test-TEST001';
        c1.LastName = 'testtest';
        c1.Salutation = 'Mr.';
        c1.Title = 'test-data';
        c1.Email = 'xxx@gmail.com';
        c1.Phone = '123456789';
        c1.Subscription_Type__c = 'Track and Trace';
        c1.Active_Subscription__c =true;
        c1.Sync_to_Pardot__c = 'Yes';
        c1.RecordTypeId=subscriptionRecId;    
        listOfContact.add(c1); 
        
        Contact c2 = new Contact();
        c2.AccountId = a1.Id;
        c2.LastName = 'testtest';
        c2.Salutation = 'Mr.';
        c2.Email = 'xxx@gmail.com';
        c2.Phone = '123456789';
        c2.RecordTypeId=shopownerRecId; 
        c2.Portal_User_Name__c='test';
        listOfContact.add(c2);   
        insert listOfContact;

        New_Media_Usage__c  n = new New_Media_Usage__c();
        n.Hoya_Account_ID__c = a1.Id;
        n.External_key__c = '66';
        n.Tool__c = 'SXN orders';
        n.Transaction_Date__c= '202403';  
        insert n; 
      }
    @IsTest
    static void testmultipleClass2(){
        Test.StartTest();  
		    Account acc2 = [SELECT Id,Account_Status__c FROM Account Where Hoya_Account_ID__c = 'SO4900TEST001'];
		    List<Contact> listContact = [SELECT ID FROM Contact WHERE AccountId=: acc2.ID];
			tabActivationPortalRegistrationIndicator.getAIIndicators(acc2.Id);
            listContact[0].accountId = null;
            update listContact;
            tabActivationPortalRegistrationIndicator.getAIIndicators(acc2.Id);
            acc2.Account_Number_ILog__c = ' ';
            update acc2;
            tabActivationPortalRegistrationIndicator.getAIIndicators(acc2.Id);
        Test.StopTest();
    }
    @IsTest
    static void testmultipleClass6(){
        Test.StartTest();  
        Account acc2 = [SELECT Id,Account_Status__c FROM Account Where Hoya_Account_ID__c = 'TE-012355'];
        tabActivationPortalRegistrationIndicator.getAIIndicators(acc2.Id);
        Test.StopTest();
    }
    @IsTest
    static void testmultipleClassIlog(){
        Test.StartTest();  
		    Account acc2 = [SELECT Id,Account_Status__c FROM Account Where Hoya_Account_ID__c = 'SO4900TEST001'];
            list<New_Media_Usage__c> listOfNewMedia = [SELECT ID,Hoya_Account_ID__c 
                                                      FROM New_Media_Usage__c  WHERE Hoya_Account_ID__c =:acc2.id];
           list<contact> listofcontact = [SELECT id from contact where Portal_User_Name__c='test'];
            listofcontact[0].AccountId=null;
            update listofcontact;
            acc2.Catalog_name__c = ' ';
            update acc2;
            tabActivationPortalRegistrationIndicator.getAIIndicators(acc2.Id);
           acc2.Brand_Visibility__c='';
            update acc2;
            tabActivationPortalRegistrationIndicator.getAIIndicators(acc2.Id);
            acc2.Language__c=''; 
            update acc2;
            tabActivationPortalRegistrationIndicator.getAIIndicators(acc2.Id);
            acc2.Portal__c ='';
            update acc2;
            tabActivationPortalRegistrationIndicator.getAIIndicators(acc2.Id);
        Test.StopTest();
    }
    @IsTest
    static void testmultipleClassReg(){
        Test.StartTest();  
		    Account acc2 = [SELECT Id,Account_Status__c,Portal__c,Language__c,Brand_Visibility__c FROM Account Where Hoya_Account_ID__c = 'SO4900TEST001'];
            
            acc2.Brand_Visibility__c='';
            update acc2;
            tabActivationPortalRegistrationIndicator.getAIIndicators(acc2.Id);
            acc2.Language__c=''; 
            update acc2;
            tabActivationPortalRegistrationIndicator.getAIIndicators(acc2.Id);
            acc2.Portal__c ='';
            update acc2;
            tabActivationPortalRegistrationIndicator.getAIIndicators(acc2.Id);
       Test.StopTest();
    }

}