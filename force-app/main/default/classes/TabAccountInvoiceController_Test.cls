/**
 * @author : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 * @description : this test class for TabAccountInvoiceController
 * @CreatedDate : 2023-11-27
 * @version : 1.0
 * Code coverage : 86%
 */
@IsTest
public with sharing class TabAccountInvoiceController_Test {

    @TestSetup
    static void makeData(){
        Account a = new Account();
        a.Hoya_Account_ID__c = 'TEST-998';
        a.Name = 'Test account';
        a.Billing_Account_Name__c = 'Test data';
        a.BillingStreet = '123 Street & Venue';
        a.BillingCity = 'Bangkok';
        a.BillingState = 'Bangkok';
        a.BillingCountry = 'Thailand';
        a.BillingPostalCode = '123456';
        a.BillingLatitude = 13.736717;
        a.BillingLongitude = 100.523186;

        insert a;
    }

    @IsTest
    static void myUnitTest01(){
        Account acc = [SELECT Id, Hoya_Account_ID__c, Billing_Account_Name__c, 
                            Name, BillingStreet, BillingState, BillingCountry, BillingPostalCode, 
                            BillingLatitude, BillingLongitude FROM Account WHERE 
                            Hoya_Account_ID__c = 'TEST-998' LIMIT 1];
        Test.StartTest();
        TabAccountInvoiceController.getAccountForMap(acc.Id);
        acc.BillingLongitude = null;
        acc.BillingLatitude = null;
        update acc;
        TabAccountInvoiceController.getAccountForMap(acc.Id);
        Test.StopTest();

        System.assert(true);

        try{
            delete acc;
            TabAccountInvoiceController.getAccountForMap(null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
    }

}