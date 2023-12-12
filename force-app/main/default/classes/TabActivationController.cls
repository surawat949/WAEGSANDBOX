public with sharing class TabActivationController {
    public TabActivationController() {

    }

    @AuraEnabled
    public static Seiko_data__c getSeikoData(Id accountId){
        Seiko_data__c seikoSales = null;
        try {
            seikoSales = [select Id from Seiko_Data__c where Account__c=:accountId];                      

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return seikoSales;
    }
}