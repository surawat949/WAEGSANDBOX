@isTest
public class TabMVCActivationController_test {
	@IsTest
    static void runTest(){
        Account acc = new Account();
        acc.Name='sales test account';
        acc.hoya_account_id__c='SO3399999xx';
        acc.AnnualRevenue = 10000;
        acc.RecordTypeId='012b00000000P38';        
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Rep';
        con.AccountId = acc.Id;        
        insert con;          
        
        ECP_Training__c training = new ECP_Training__c();
        training.Training_status__c ='completed';
        training.start__c = System.today()-2;
        training.Account__c = acc.Id;
        training.Type__c = 'In Store';
        training.Training__c = 'MIYOSMART';
        Insert training;
        
        ECP_Training_Member__c member = new ECP_Training_Member__c();
        member.Training__c = training.Id;
        member.Contact__c = con.Id;
        Insert member;
        
        Last_Sales_Statistics__c sales= new Last_Sales_Statistics__c();
        sales.Account__c = acc.Id;
        sales.MiyoSmart_Last_12_Mo_Qty__c = 12;
        sales.MiyoSmart_Last_Mo_Qty__c = 2;
        Insert sales;
        
        Test.startTest();
        TabMVCActivationController.accountId = acc.Id;
        TabMVCActivationController.getReferringOpticiansCountList(con.Id);
        TabMVCActivationController.getLastTrainingDate(con.Id);
        TabMVCActivationController.getOrdersMiyoSmartRelatedList(con.Id);
        TabMVCActivationController.getRefferingOptsLst(con.Id, true);
        TabMVCActivationController.getRefferingOptsLst(con.Id, false);
        Test.StopTest();
    }
}