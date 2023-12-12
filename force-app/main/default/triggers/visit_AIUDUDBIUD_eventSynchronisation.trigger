/**
 *  This trigger is used to synchronize from visit to event
 *
 @author 	Peng Zhu
 @created 	2013-03-28
 @version 	1.0
 @since 	25.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-03-28 Peng Zhu <peng.zhu@itbconsult.com>
 * - Created
 */
trigger visit_AIUDUDBIUD_eventSynchronisation on Visits__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	//************************* BEGIN Before Trigger **********************************************
	System.debug(JSON.serialize(trigger.new));
	if(Trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
        for(Visits__c v : trigger.new) {

            
			if(v.Is_All_Day_Event__c){
				if (v.Start_Time__c != null) {
					v.Start_Time__c = ClsVisitUtil.calculateDateTimeValue(v.Start_Time__c.date(), '00:00');
				}
				if (v.End_Time__c != null) {
					v.End_Time__c = ClsVisitUtil.calculateDateTimeValue(v.End_Time__c.date(), '00:00');
				}
			}
        }
	}
	//************************* END Before Trigger ************************************************
	
	//************************* BEGIN After Trigger ***********************************************
	//synchronize
	if(!TriggerRecursionDefense.visitEventSync && Trigger.isAfter) {
	    if(trigger.isAfter) {
	    	TriggerRecursionDefense.visitEventSync = true;
	        String mode;
	        list<Visits__c> list_new = new list<Visits__c>();
	        list<Visits__c> list_old = new list<Visits__c>();
	        if(Trigger.isInsert || Trigger.isUnDelete) {
	            mode = ClsVisitUtil.MODE_INSERT;
	            list_new = trigger.new; 
	        }
	        else if(Trigger.isUpdate) {
	            mode = ClsVisitUtil.MODE_UPDATE;
	            list_new = trigger.new; 
	            list_old = trigger.old; 
	        }
	        else if(Trigger.isDelete) {
	            mode = ClsVisitUtil.MODE_DELETE;
	            list_old = trigger.old; 
	        }
	        ClsVisitUtil.calculateTriggerOnVisit(mode, list_new, list_old);
	    	TriggerRecursionDefense.visitEventSync = false;
        }
    }
	//************************* END After Trigger *************************************************
}