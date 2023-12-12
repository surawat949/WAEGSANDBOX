public class tabActivationPortalController {
	@AuraEnabled(cacheable=true)
    public static Id getSeikoDataId(Id accId){
        List<Seiko_Data__c> sales = [Select Id From Seiko_Data__c Where Account__c=:accId];
        if(sales.size() > 0){
            System.debug(sales[0].Id);
            return sales[0].Id;
        }
        else 
            return null;
    }
    @AuraEnabled(cacheable=true)
    public static Date getLastTrainingDate(Id accountId, String training){
        try {
            System.debug(accountId+''+training);
            List<ECP_Training__c> tList =[select id, Training__c, end__c from ECP_Training__c where Account__c=:accountId and training__c includes (:training) and Training_status__c='Completed' order by end__c desc];
            Date trainingDate =null;
            System.debug('XXX tList size = ' + tList.size());
            if(tList.size()>0 && tList[0].end__c!=null){
                trainingDate = date.newInstance(tList[0].end__c.year(), tList[0].end__c.month(), tList[0].end__c.day());
                System.debug('XXX Trainging date = ' + trainingDate);
            }
            return trainingDate;
        } catch (Exception e) {
            System.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=false)
    public static string startEnroll(Id accountId){
        String error = 'ok';
        try{
            Seiko_data__c s = [select Id,SVS_Digital_com_Platform_radius__c,SVS_Digital_communication_platform__c
            from Seiko_Data__c where Account__c=:accountId];
            error = ExternalWSCall.activateAccount(accountId, s.id);
            System.debug(error);
        }catch (Exception e) {
            LogException.log(e);
            System.debug(e.getMessage());
            error = e.getMessage();
            return e.getMessage();
        }
        return error;
    }
}