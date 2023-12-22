public class TabAccountNewTaskLWCController {
    @AuraEnabled(cacheable=true)
    public static ID taskRecordTypeId(){
        system.debug('>>>');
      ID SupportTask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Support_Task').getRecordTypeId();
      system.debug('>>>SupportTask'+SupportTask);
        return SupportTask; 
    }

}