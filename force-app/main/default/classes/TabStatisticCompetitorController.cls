public with sharing class TabStatisticCompetitorController {

    /**
     * =====================================================
     * @Author : Surawat Sakulmontreechai
     * @CreatedBy : Surawat Sakulmontreechai
     * @Email : surawat.sakulmontreechai@hoya.com
     * @CreatedDate : 2023-09-04
     * @CreatedBy : Surawat Sakulmontreechai
     * @LastmodifiedDate : -
     * @LastmodifiedBy : Surawat Sakulmontreechai
     * @version : 1.0
     * @apiVersion : via api 55.0
     * @description : This class support for LWC - in global competitor #Task-731 - SFDC V.2.0 Project
     */

    @AuraEnabled(cacheable=true)
    public static sObject searchDefaultRecord(string recordId, string sObjectApiName){
        System.debug('Search Default Record '+recordId);
        string recId = recordId;
        
        string sQuery = 'select Id, DurableId, label, value from picklistvalueinfo where ' +
                        'entityparticle.entitydefinition.qualifiedapiname = \''+sObjectApiName+'\' '+
                        'and entityparticle.developername = \'First_Competitor_local_name\' '+
                        'and isactive = true and value LIKE :recId order by value asc limit 1';
        System.debug('soql is =>'+sQuery);
        /*String sQuery = 'select Id, Name from '+sObjectApiName+' where Id=:recId limit 1';*/
        for(sObject obj : database.query(sQuery)){
            //System.debug(obj);
            return obj;
        }

        return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> searchLookupData(string searchKey, string sObjectApiName){
        List<sObject> returnList = new List<sObject>();
        String swildcardText = searchKey;

        if(String.isNotBlank(searchKey)){
            swildcardText = '%'+searchKey+'%';
            String sQuery = 'select Id, DurableId, label, value from picklistvalueinfo where ' +
                        'entityparticle.entitydefinition.qualifiedapiname = \''+sObjectApiName+'\' '+
                        'and entityparticle.developername = \'First_Competitor_local_name\' and isactive = true '+
                        'and value LIKE: swildcardText order by value asc';
        
            /*String sQuery = 'select Id, Name from '+sObjectApiName+' where Name LIKE: swildcardText order by name asc limit 100';*/
            for(sObject obj : database.query(sQuery)){
                returnList.add(obj);
            }
        }else{
            swildcardText = '';
        }
        
        
        //System.debug('XXX Get data =>'+returnList.size());
        return returnList;
    }

    @AuraEnabled(cacheable=false)
    public static void UpdateCompetitor(String recordId, String firstCompetitorName, String secondCompetitorName){
        try {
            List<Account> updateList = new List<Account>();
            List<Account> acc = new List<Account>([SELECT Id, Hoya_Account_ID__c, First_Competitor_local_name__c, First_Competitor_Global_Name__c, Second_Competitor_Local_Name__c, Second_Competitor_global_name__c FROM Account WHERE Id=:recordId]);
            for(Account a : acc){
                if((String.isNotBlank(firstCompetitorName)) || (String.isNotBlank(secondCompetitorName))){
                    a.First_Competitor_local_name__c = String.valueOf(firstCompetitorName);
                    a.Second_Competitor_Local_Name__c = String.valueOf(secondCompetitorName);
                    updateList.add(a);
                    
                }else{
                    a.First_Competitor_Local_Name__c = '';
                    a.First_Competitor_Global_Name__c = '';
                    a.Second_Competitor_global_name__c = '';
                    a.Second_Competitor_Local_Name__c = '';
                    updateList.add(a);
                    
                }

            }
            if(updateList.size()>0){
                update updateList;

                List<Global_Competitor_Entity__mdt> comp_mdt = new List<Global_Competitor_Entity__mdt>([SELECT Id, 	Competitor_Entity_Name__c, 
                                                                        First_Competitor_Local_Name__c, First_Competitor_Global_Name__c 
                                                                        FROM Global_Competitor_Entity__mdt WHERE Competitor_Entity_Name__c=:firstCompetitorName]);
                Map<String, String> MapGlobalCompetitor = new Map<String, String>();
                for(Global_Competitor_Entity__mdt eachEntity : comp_mdt){
                    if(String.isNotBlank(eachEntity.Competitor_Entity_Name__c) && String.isNotBlank(firstCompetitorName)){
                        String key = eachEntity.Competitor_Entity_Name__c;
                        MapGlobalCompetitor.put(key, eachEntity.First_Competitor_Global_Name__c);
                    }
                }
                List<Account> updGlobalCompetitor = new List<Account>();
                List<Account> updSecondCompetitor = new List<Account>();
                List<Account> newGlobalCompetitor = new List<Account>([SELECT First_Competitor_Local_Name__c, First_Competitor_Global_Name__c, Second_Competitor_global_name__c, Second_Competitor_Local_Name__c FROM Account WHERE Id=:recordId]);
                for(Account a : newGlobalCompetitor){
                    System.debug('Key = > '+MapGlobalCompetitor);
                    if(!MapGlobalCompetitor.isEmpty() && String.isNotBlank(a.First_Competitor_Local_Name__c)){
                        String key = a.First_Competitor_Local_Name__c;
                        String FirstGlobalCompetitor = MapGlobalCompetitor.get(key);
                        if(FirstGlobalCompetitor!=null){
                            a.First_Competitor_Global_Name__c = FirstGlobalCompetitor;
                            updGlobalCompetitor.add(a);
                            
                        }

                    }else if(String.isBlank(a.First_Competitor_Local_Name__c) || a.First_Competitor_Local_Name__c==''){
                        a.First_Competitor_Global_Name__c = '';
                        updGlobalCompetitor.add(a);
                        
                    }else{
                        a.First_Competitor_Global_Name__c = 'Other';
                        updGlobalCompetitor.add(a);
                        

                    }
                }
                if(updGlobalCompetitor.size()>0){
                    update updGlobalCompetitor;
                }

                //update 2nd competitor
                List<Global_Competitor_Entity__mdt> comp2_mdt = new List<Global_Competitor_Entity__mdt>([SELECT Id, Competitor_Entity_Name__c, 
                                                                                                        First_Competitor_Local_Name__c, First_Competitor_Global_Name__c 
                                                                                                        FROM Global_Competitor_Entity__mdt 
                                                                                                        WHERE Competitor_Entity_Name__c=:secondCompetitorName]);
                Map<String, String> MapSecondCompetitor = new Map<String, String>();
                for(Global_Competitor_Entity__mdt eachEntity : comp2_mdt){
                    if(String.isNotBlank(eachEntity.Competitor_Entity_Name__c) && String.isNotBlank(secondCompetitorName)){
                        String key = eachEntity.Competitor_Entity_Name__c;
                        MapSecondCompetitor.put(key, eachEntity.First_Competitor_Global_Name__c);
                    }
                }

                for(Account a : newGlobalCompetitor){
                    System.debug('2nd key=>'+MapSecondCompetitor);
                    if(!MapSecondCompetitor.isEmpty() && String.isNotBlank(a.Second_Competitor_Local_Name__c)){
                        String key = a.Second_Competitor_Local_Name__c;
                        String SecondCompetitor = MapSecondCompetitor.get(key);
                        if(SecondCompetitor!=null){
                            a.Second_Competitor_global_name__c = SecondCompetitor;
                            updSecondCompetitor.add(a);
                        }
                    }else if(String.isBlank(a.Second_Competitor_Local_Name__c) || a.Second_Competitor_Local_Name__c == ''){
                        a.Second_Competitor_global_name__c = '';
                        updSecondCompetitor.add(a);
                    }else{
                        a.Second_Competitor_global_name__c = 'Other';
                        updSecondCompetitor.add(a);
                    }
                }
                if(updSecondCompetitor.size()>0){
                    update updSecondCompetitor;
                }
            }

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static sObject searchLookupUserDefault(String recordId, String sObjectApiName){
        String recId = recordId;
        String sQuery = 'SELECT Id, Name FROM '+sObjectApiName+ ' WHERE Id=:recid LIMIT 1';

        for(sObject obj : database.query(sQuery)){
            return obj;
        }
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> searchLookupUser(String searchKey, String sObjectApiName){
        List<sObject> returnList = new List<sObject>();
        String sCommunityUser = '%Customer Community%';
        String sWildCardText = searchKey;

        if(String.isNotBlank(searchKey)){
            sWildCardText = '%'+searchKey+'%';
        }

        String sQuery = 'SELECT Id, Name FROM '+sObjectApiName+ ' WHERE (Name LIKE:sWildCardText) AND (IsActive=true) AND (NOT(Profile.Name LIKE:sCommunityUser))';
        for(sObject obj : database.query(sQuery)){
            returnList.add(obj);
        }
        return returnList;
    }

    @AuraEnabled(cacheable=true)
    public static string getFirstLocalCompetitorName(String recordId){
        try {
            String FirstCompetitorLocalName = [SELECT Id, First_Competitor_Local_Name__c FROM Account WHERE Id=:recordId].First_Competitor_Local_Name__c;
            //System.debug(FirstCompetitorLocalName);
            return FirstCompetitorLocalName;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static string getSecondLocalCompetitorName(String recordId){
        try {
            String SecondCompetitorLocalName = [SELECT Id, Second_Competitor_Local_Name__c FROM Account WHERE Id=:recordId].Second_Competitor_Local_Name__c;
            return SecondCompetitorLocalName;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static double getFirstCompetitorSOW(String recordId){
        try {
            Double FirstComp = [SELECT First_Competitor_SOW_Last_3_Month__c FROM Last_Sales_Statistics__c WHERE Account__c=:recordId].First_Competitor_SOW_Last_3_Month__c;
            System.debug(FirstComp);
            return FirstComp;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=false)
    public static void CreateNewCompetitorReq(String subject, String Instruction, String assignto, Date duedate, String sStatus, String accountName){
        try {
            String StandardHoyatask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Standard_New').getRecordTypeId();
            Task t = new Task(
                Subject = subject,
                Instructions__c = Instruction,
                OwnerId = assignto,
                ActivityDate = duedate,
                Status = sStatus,
                RecordTypeId = StandardHoyatask,
                WhatId = accountName,
                Account__c = accountName

            );
            insert t;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static sObject searchDefaultAccountName(String recordId, String sObjectApiName){
        String recId = recordId;
        String sQuery = 'SELECT Id, Hoya_Account_ID__c, Name FROM '+sObjectApiName+' WHERE Id=:recId LIMIT 1';
        for(sObject obj : database.query(sQuery)){
            return obj;
        }
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> searchAccountName(String recordId, String sObjectApiName, String searchKey){
        List<sObject> returnList = new List<sObject>();
        String recId = recordId;
        String swildcardtext = searchKey;

        if(String.isNotBlank(searchKey)){
            swildcardtext = '%'+searchKey+'%';
            String sQuery = 'SELECT Id, Hoya_Account_ID__c, Name FROM '+sObjectApiName+' WHERE Name LIKE:swildcardtext AND Id=:recId ORDER BY Name ASC';
            for(sObject obj : database.query(sQuery)){
                returnList.add(obj);
            }
        }else{
            swildcardtext = '';
        }
        return returnList;
    }
}