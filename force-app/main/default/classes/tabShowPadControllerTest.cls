@IsTest
public class tabShowPadControllerTest {
     @TestSetup
      static void makeData(){
         Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'SO4900TEST001';
        a1.Name = 'Test Account';
        a1.Shop_Name__c = 'Test Account';
       insert a1;
          
       Account acc2 = new Account(
            Name = 'Test AccTESR',
            phone='0103030408',
            Account_Status__c='Closed'
            
        );
        insert acc2;  
        DateTime currentDate = DateTime.now();
        Contact c1 = new Contact();
        c1.AccountId = a1.Id;
        c1.FirstName = 'test-TEST001';
        c1.LastName = 'testtest';
        c1.Salutation = 'Mr.';
        c1.Title = 'test-data';
        c1.Email = 'xxx@gmail.com';
        c1.Phone = '123456789';
        DateTime sixMonthsAgo = currentDate.addMonths(-6).addDays(2);
        c1.ShowpadForSF__Showpad_Last_Activity_Date__c  = sixMonthsAgo;
        c1.ShowpadForSF__Showpad_Last_View_Date__c = currentDate.addMonths(-3);
        insert c1;  
      }
    @IsTest
    static void testmultipleClass2(){
      Account acc1 = [SELECT Id,Account_Status__c FROM Account Where Name = 'Test AccTESR'];
     Account acc2 = [SELECT Id,Account_Status__c FROM Account Where Hoya_Account_ID__c = 'SO4900TEST001'];
     List<Contact> listContact = [SELECT ID,AccountId,ShowpadForSF__Showpad_Last_Activity_Date__c, 
                                  ShowpadForSF__Showpad_Last_View_Date__c FROM Contact WHERE AccountId=: acc2.ID];
        Test.StartTest();
        tabShowPadController.getAIIndicators(acc2.Id);
        tabShowPadController.getAIIndicators(acc1.Id);
        Test.StopTest();
   
  

    }
}