public class LiveChatTranscriptTriggerHelper {
    public static void doPopulateContactToAgent(List<LiveChatTranscript> liveChatTranscriptList ){
        Map<String,String> emailHoyaCombinationMap = new Map<String,String>();
        for(LiveChatTranscript liveChatTranscriptRecord : liveChatTranscriptList){
            emailHoyaCombinationMap.put(liveChatTranscriptRecord.Hoya_Account_ID__c,liveChatTranscriptRecord.Customer_Email__c);
        }
        if(emailHoyaCombinationMap.size() > 0){
            Map<String,Contact> conMap = new Map<String,Contact>();
            for(Contact contactRec : [select id,Email,AccountId,Account.Hoya_Account_ID__c from contact where Account.Hoya_Account_ID__c IN :emailHoyaCombinationMap.keySet() and email IN : emailHoyaCombinationMap.values()]){
                conMap.put(contactRec.Account.Hoya_Account_ID__c,contactRec);
            }
            if(conMap.size() > 0){
                for(LiveChatTranscript liveChatTranscriptRecord : liveChatTranscriptList){
                    if(conMap.containsKey(liveChatTranscriptRecord.Hoya_Account_ID__c)){
                        liveChatTranscriptRecord.ContactId = conMap.get(liveChatTranscriptRecord.Hoya_Account_ID__c).Id;
                        if(conMap.get(liveChatTranscriptRecord.Hoya_Account_ID__c).AccountId != null)
                            liveChatTranscriptRecord.AccountId = conMap.get(liveChatTranscriptRecord.Hoya_Account_ID__c).AccountId;
                    }
                }
            }
        }
    }
    public static void doCreateTaskforChat(List<LiveChatTranscript> liveChatTranscriptList, Map<Id,LiveChatTranscript> oldliveChatTranscriptMap){  
        List<Task> listOfTasks = new List<Task>();    
        for(LiveChatTranscript liveChatTranscriptRecord : liveChatTranscriptList){
            if(liveChatTranscriptRecord.Status == 'Completed'){
                Task taskRecord = new Task ();
                taskRecord.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('serviceFlow_AgentCreateTask').getRecordTypeId();                
                taskRecord.CallType = 'Inbound';
                taskRecord.Description = String.isNotBlank(liveChatTranscriptRecord.Body) ? liveChatTranscriptRecord.Body.stripHtmlTags() : '';
                //taskRecord.SFlow_Subject__c = liveChatTranscriptRecord.Subject__c;
                taskRecord.Status = 'New';
                taskRecord.ActivityDate = System.Today().addDays(7);
                taskRecord.Subject = 'Chat';
                taskRecord.TaskSubtype = 'Task';
                taskRecord.WhatId = liveChatTranscriptRecord.AccountId;
                taskRecord.Account__c = liveChatTranscriptRecord.AccountId;
                taskRecord.serviceFlow_Origin__c = 'Live Chat';
                listOfTasks.add(taskRecord);
            }
        }
        if(listOfTasks.size() > 0){
            insert listOfTasks;
            system.debug('******'+JSON.serializePretty(listOfTasks));
        }
    }
}