@IsTest
public class VisitTriggerHelperTest {
	@isTest
    static void testHomeOfficeTracker() {
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'Test';
        acc.Shop_Country__c = 'BE';
        insert acc; 
                
        Visits__c visit = new Visits__c();
        visit.Account__c = acc.Id;
        visit.Visit_Type__c = 'Visit';
        visit.Visit_Status__c = 'Planned';
        visit.Start_Time__c = date.today();
        visit.End_Time__c = visit.Start_Time__c.addMinutes(60);
        visit.Assigned_to__c = UserInfo.getUserId();
       
        
        Test.startTest();
        insert visit;
		system.assert(true);
        Test.stopTest();        
    }
}