@isTest
public class tabActivationEquipmentsController_test {
  	@IsTest
    static void runTestCtrl(){         
        Account acc = new Account();
        acc.Name='sales test account';
        acc.hoya_account_id__c='SO3399999xx';
        acc.RecordTypeId='012b00000000P38';        
        insert acc;
        
        New_Media_Usage__c media = new New_Media_Usage__c();
        media.External_key__c = 'SO3399999xxeColumn Lens Selection202210';
        media.Hoya_Account_ID__c = acc.Id;
        media.Quantity__c = 2;
        media.Tool__c = 'eColumn Lens Selection';
        media.Transaction_Date__c = '202210';        
        insert media;

        ECP_Training__c training = new ECP_Training__c();
        training.Account__c = acc.Id;
        training.Training_status__c = 'Completed';
        training.Training__c = 'HoyaiLog orders';     
        training.Type__c = 'In Store';
        training.start__c = System.today()-2;
        insert training;
        
        tabActivationEquipmentsController.getLastTrainingDate(acc.Id,'HoyaiLog orders');
        tabActivationEquipmentsController.getLastMediaUsage(acc.Id,'HoyaiLog orders','ExactMatch');
        tabActivationEquipmentsController.getLastMediaUsage(acc.Id,'eColumn Lens Selection%','LikeMatch');
        tabActivationEquipmentsController.getEquipmentsChart(acc.Id,'HoyaiLog orders','ExactMatch');
        tabActivationEquipmentsController.getEquipmentsChart(acc.Id,'eColumn Lens Selection%','LikeMatch');
    }
}