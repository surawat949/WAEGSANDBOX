@isTest
public class TabVisitsTrainingsControllerTest {
    
    public TabVisitsTrainingsControllerTest() {
        
    }
    
    @TestSetup
    static void makeData(){
        Account hvnaAcc = new Account();
        hvnaAcc.Hoya_Account_ID__c = 'US1234512';
        hvnaAcc.CurrencyIsoCode = 'EUR';
        hvnaAcc.Name = 'HVNA Test';
        insert hvnaAcc;
        
        ECP_Training__c  training =new ECP_Training__c();
        training.Account__c =hvnaAcc.Id;
        training.start__c = date.today();
        training.Training__c ='SEIKO Pro';
        training.Training_status__c  ='Completed';
        training.Type__c = 'Webinar';
        insert training;
        
        eLearning__c  eLearning =new eLearning__c();
        eLearning.Account__c =hvnaAcc.Id;
        eLearning.User_Name__c = 'mohan@mohan.com';
        eLearning.email__c ='mohan@mohan.com';
        eLearning.status__c  ='Inscrit';
        eLearning.Name  ='NameTest';
        eLearning.Course__C  ='Maths';
        eLearning.End_Date__c  =date.today() + 7;
        insert eLearning;
        
    }
    
    @isTest
    static void campTest(){
        Account a=[Select Id from account Limit 1];
        TabVisitsTrainingsController.getTrainingRecords(a.Id);
        TabVisitsTrainingsController.getElearningRecords(a.Id);
    }
    
}