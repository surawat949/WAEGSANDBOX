public with sharing class tabAccountAddressLWCController {

    /**
     * =====================================================
     * @Author : Surawat Sakulmontreechai
     * @CreatedBy : Surawat Sakulmontreechai
     * @Email : surawat.sakulmontreechai@hoya.com
     * @CreatedDate : 2023-06-06
     * @CreatedBy : Surawat Sakulmontreechai
     * @LastmodifiedDate : 2023-08-28
     * @LastmodifiedBy : Surawat Sakulmontreechai
     * @version : 1.0
     * @apiVersion : via api 49.0 or higher (force.com)
     * @description : This class support for LWC - tabAddressAccount and maybe another LWC using in project SFDC V.2.0 Project
     */

    /** Add this class for account tabAccountAddress LWC - 2023-06-06 **/
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsRelatedAccount(String receivedId){
        List<Contact> conList = [SELECT Id, Name, Contact_Record_Type__c, Salutation, Title, Email, Phone 
                                    FROM Contact WHERE AccountId=:receivedId ORDER BY Name ASC LIMIT 5];
        System.debug('Get Contacts Related to Account == > '+conList);
        return conList;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getConCount(String receivedId){
        List<Contact> con = [SELECT Id FROM Contact WHERE AccountId=:receivedId];
        return con;
    }

    /** Add this class for reuseable related list apex for Salesforce SFDC V.2.0 Project **/
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getDataAndColumns(String sObjectName, List<String> sObjectFieldsName, String recordId, String AndWhere, String OwnerWhere, String OrderBy){
        try {
            Map<String, Schema.SObjectField> m = Schema.describeSObjects(sObjectName.split(','))[0].fields.getMap();
            List<Object> columns = new List<Object>();
            for(String fieldName : sObjectFieldsName){
                Schema.DescribeFieldResult dfr = m.get(fieldName).getDescribe();
                Map<String, Object> column = new Map<String, Object>{
                    'label' => dfr.getLabel(),
                    'fieldName' => dfr.getName(),
                    'type' => String.valueOf(dfr.getType()).toLowerCase(),
                    'sorttable' => true
                };
                columns.add(column);
            }
            String query = 'SELECT '+String.join(sObjectFieldsName, ', ') + ' FROM ' + sObjectName + OwnerWhere + '\''+recordId+'\')'
                            + AndWhere + OrderBy;
            System.debug('Query String == > '+query);
            List<Object> records = Database.query(query);
            Map<String, Object> dataColumns = new Map<String, Object>{
                'columns' => columns,
                'data' => records
            };
            System.debug('XXX Get Columns & Data == > '+dataColumns.size()+' Data == >'+dataColumns);
            return dataColumns;
        } catch (Exception e) {
            LogException.log(e);
            return new Map<String, Object>{'Exception == > '=>e.getMessage()};
        }
    }

    /** Added below class for copied email address to all function - support in Salesforce SFDC V.2.0 Project */

    @AuraEnabled(cacheable=false)
    public static String UpdateAccountEmail(String receivedId){
        try {
            List<Account> accToUpdate = new List<Account>();
            String AccountEmail = [SELECT Shop_email_address__c FROM Account WHERE Id=:receivedId LIMIT 1].Shop_email_address__c;
            List<Account> accList = [SELECT Surveys_Email__c, Email__c, Confidential_Email_Address__c FROM Account 
                                    WHERE (Id=:receivedId) LIMIT 1];
            if((AccountEmail!='') || (AccountEmail!=null)){
                for(Account a : accList){
                    if(a.Surveys_Email__c==null){a.Surveys_Email__c = AccountEmail;}
                    if(a.Email__c==null){a.Email__c = AccountEmail;}
                    //if(a.Track_and_Trace_Email_Address__c==null){a.Track_and_Trace_Email_Address__c = AccountEmail;}
                    if(a.Confidential_Email_Address__c==null){a.Confidential_Email_Address__c = AccountEmail;}
                    accToUpdate.add(a);

                }
            }else{
                accToUpdate.clear();
            }

            if((!accToUpdate.isEmpty()) && accToUpdate!=null){
                update accToUpdate;
                System.debug('XXX Update email copied to all done, values copied == > '+AccountEmail);
                return 'Account email copied to all update successful';
            }else{
                System.debug('XXX Email address blank or null value, cannot update');
                return 'No record update';
            }

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=false)
    public static void createTask(String Sject, String relatedTo, String Comment, String assignTo, Date DueDate, String sStatus, String sFlowContact, String CopyTo, String AccountId){
        try {
            String StandardHoyatask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Standard_New').getRecordTypeId();
            Task t = new Task(
                Subject = Sject,
                WhatId = relatedTo,
                Instructions__c = Comment,
                OwnerId = assignTo,
                ActivityDate = DueDate,
                Status = sStatus,
                RecordTypeId = StandardHoyatask,
                WhoId = sFlowContact,
                Copy_To__c = CopyTo,
                Account__c = AccountId
            );
            insert t;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=false)
    public static void createNewContact(String accountid, String salutation, String firstname, String lastname, String title, String recordtypeid, String education, String phone, String mobile, String email, String accTemplate, Boolean SystemInvitationEmail, Boolean SendInvitationPortal, Boolean SendImmDiately){
        try {
            Contact c = new Contact(
                AccountId = accountid,
                Salutation = salutation,
                FirstName = firstname,
                LastName = lastname,
                Title = title,
                RecordTypeId = recordtypeid,
                Education__c = education,
                Phone = phone,
                MobilePhone = mobile,
                Email = email,
                Account_Template__c = accTemplate
                //System_Invitation_Email__c = SystemInvitationEmail,
                //Send_Invitation_Portal__c = SendInvitationPortal
                //Send_Invite_Email_Immediately__c = SendImmDiately

            );
            insert c;
            if(( SendImmDiately== true) && (c.Account_Template__c!=null)){
              //  System.debug('=== START SEND INVITATION IMMEDIATELY === '+c.Id);
               // System.debug('=== IF Send_Invite_Email_Immediately__c IS CHECKED ==== '+c.Send_Invite_Email_Immediately__c);
                //Call apex class send the invitation to end-user immediately
                SendRegistrationInvite_Controller.sendRegistrationInvite(c.Id);
            }

        } catch (Exception e) {
           // LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**Using this class for reusable in custom lookup field and you need to create by yourself
     * instead using record-api.
     * added : 2023-06-16
     * added by : Surawat Sakulmontreechai
     * last modified by : Surawat Sakulmontreechai
     */
    @AuraEnabled(cacheable=true)
    public static list<sObject> searchLookupData(string searchKey , string sObjectApiName, string CriteriaName, String recordId) {    
        List < sObject > returnList = new List < sObject > ();
        string sWildCardText = '%' + searchKey + '%';
        string sRecId = recordId;
        System.debug('recordId '+recordId);
        System.debug('Check data sObjectApiName  '+sObjectApiName);
        string sQuery;
        if(sObjectApiName =='Contact' &&  CriteriaName.contains('Opthalmologist')){
                sQuery = 'Select Id, Name, Account.Name, Hoya_Account_ID__c From ' + sObjectApiName + ' Where Name Like : sWildCardText '+CriteriaName+' AND AccountId != :sRecId  order by name asc';
            
            
         }
        else{
             sQuery = 'Select Id,Name,Hoya_Account_ID__c From ' + sObjectApiName + ' Where Name Like : sWildCardText '+CriteriaName+' AND AccountId= : sRecId order by name asc';
        }
         System.debug('here the soql query  '+sQuery);
        for (sObject obj: database.query(sQuery)) {
            System.debug('Check data '+obj);
            returnList.add(obj);
        }
        return returnList;
    }
    
    // Method to fetch lookup default value 
    @AuraEnabled(cacheable=true)
    public static sObject searchDefaultRecord(string recordId , string sObjectApiName) {
        string sRecId = recordId;    
        string sQuery = 'Select Id,Name,Hoya_Account_ID__c From ' + sObjectApiName + ' Where Id = : sRecId LIMIT 1';
        for (sObject obj: database.query(sQuery)) {
            return obj;
        }
        return null;
    }

    /**Add this class for contact id string */
    @AuraEnabled(cacheable=true)
    public static String getContactId(String recordId){
        String contactId = [SELECT Id FROM Contact WHERE AccountId=:recordId LIMIT 1].Id;
        System.debug('XXX Get ContactId == > '+contactId);
        return contactId;
       
    }
    /** Get Contact Record Type ***/
    @AuraEnabled(cacheable=true)
    public static List<RecordType> getContactRecordTypeDescribe(){
        List<RecordType> rt = [SELECT Id, Name FROM RecordType WHERE (SObjectType='Contact') 
                                    AND (IsActive=true) AND (Name IN('Shop Owner', 'Employee', 'Opthalmologist'))
                                    ORDER BY Name ASC];
        System.debug('Get Contact Record Type == > '+rt);
        return rt;
    }
    /**get contact record type == not in contact rec.type above */
    @AuraEnabled(cacheable=true)
    public static List<RecordType> getContactRecordTypeDescribeNotIn(){
        try {
            List<RecordType> rt = [SELECT Id, Name FROM RecordType WHERE (SObjectType='Contact')
                                    AND (IsActive=true) AND (Name NOT IN('Shop Owner', 'Employee', 'Opthalmologist'))
                                    ORDER BY Name ASC];
            System.debug('Get Contact Rec.Type NOT IN'+rt);
            return rt;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**Get Account template data == Account__c = AccountId in Contact */
    @AuraEnabled(cacheable=true)
    public static List<Account_Template__c> getAccountTemplateForAccountId(String recordId){
        List<Account_Template__c> accTemplate = [SELECT Id, Name FROM Account_Template__c
                                                        WHERE Account__c=:recordId
                                                        ORDER BY LastmodifiedDate DESC LIMIT 1];
        System.debug('Account Template '+accTemplate);
        return accTemplate;
       
    }

    /** Added 2023-06-27 to getting about label and value (api) for Langauge_pick__c Contact object 
     * should upgrade to dynamic by pass value sObjectType and sFieldName to value in apex class
    */
    @AuraEnabled(cacheable=true)
    public static List<optionSet> getPicklistLanguage(){
        try {
            Schema.DescribeFieldResult fieldResult = Contact.Language_Pick__c.getDescribe();
            List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
            List<optionSet> dataset = new List<optionSet>();
            for(Schema.PicklistEntry pickListVal : pEntry){
                if(pickListVal.IsActive()){
                    String PickListLabelName = pickListVal.getLabel();
                    String PickListValueName = pickListVal.getValue();
                    dataset.add(new optionSet(PickListLabelName, PickListValueName));
                }
            }
            System.debug('XXX get data for contact language == > '+dataset.size()+' record(s)'+dataset);
            return dataset;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getpicklistEducationValues(){
        try {
            Schema.DescribeFieldResult fieldResult = Contact.Education__c.getDescribe();
            List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
            List<optionSet> dataset = new List<optionSet>();
            for(Schema.PicklistEntry picklistval : pEntry){
                if((picklistval.IsActive()) &&(picklistval.getValue()=='Optician' || picklistval.getValue()=='Optometrist' || picklistval.getValue()=='Ophtalmologist')){
                    String pListLabelName = picklistval.getLabel();
                    String pListValueName = picklistval.getValue();
                    dataset.add(new optionSet(pListLabelName, pListValueName));
                }
            }
            System.debug('XXX Get Picklist value, Education ==> '+dataset);
            return dataset;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getpicklistEducationValuesRest(){
        try {
            Schema.DescribeFieldResult fieldResult = Contact.Education__c.getDescribe();
            List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
            List<optionSet> dataset = new List<optionSet>();
            for(Schema.PicklistEntry picklistval : pEntry){
                if((picklistval.IsActive()) && (picklistval.getValue()!='Optician') && (picklistval.getValue()!='Optometrist') && (picklistval.getValue()!='Ophtalmologist')){
                    String pListLabelName = picklistval.getLabel();
                    String pListValue = picklistval.getValue();
                    dataset.add(new optionSet(pListLabelName, pListValue));
                }
            }
            System.debug('XXX Get Picklist value, Eduction rest =>'+dataset);
            return dataset;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getContactRecordTypeShopOwner(){
        try {
            List<optionSet> dataset = new List<optionSet>();
            for(RecordTypeInfo info : Contact.SObjectType.getDescribe().getRecordTypeInfos()){
                if((info.IsActive()) && (info.getDeveloperName()=='Shop_Owner')){
                    dataset.add(new optionSet(info.getName(), info.getRecordTypeId()));
                }
            }
            System.debug('XXX Get Record Type Shop Owner '+dataset);
            return dataset;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getContactRecordTypeEmployee(){
        try {
            List<optionSet> dataset = new List<optionSet>();
            for(RecordTypeInfo info : Contact.SObjectType.getDescribe().getRecordTypeInfos()){
                if((info.IsActive()) && (info.getDeveloperName()=='Employee')){
                    dataset.add(new optionSet(info.getName(), info.getRecordTypeId()));
                }
            }
            System.debug('XXX Get Record Type Employee '+dataset);
            return dataset;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getContactRecordTypeOpthal(){
        try {
            List<optionSet> dataset = new List<optionSet>();
            for(RecordTypeInfo info : Contact.SObjectType.getDescribe().getRecordTypeInfos()){
                if((info.IsActive()) && (info.getDeveloperName()=='Opthalmologist')){
                    dataset.add(new optionSet(info.getName(), info.getRecordTypeId()));
                }
            }

            System.debug('XXX Get Record Type Opthalmologist '+dataset);
            return dataset;
            
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getContactRecordTypeRest(){
        try {
            List<optionSet> dataset = new List<optionSet>();
            for(RecordTypeInfo info : Contact.SObjectType.getDescribe().getRecordTypeInfos()){
                if((info.IsActive()) && (info.IsMaster()==false) && (info.getDeveloperName()!='Shop_Owner' || info.getDeveloperName()!='Employee' || info.getDeveloperName()!='Opthalmologist')){
                    dataset.add(new optionSet(info.getName(), info.getRecordTypeId()));
                }
            }
            System.debug('XXX Get Record Type in rest = >'+dataset);
            return dataset;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class optionSet{
        public optionSet(String label, String values){
            this.Label = label;
            this.values = values;
        }

        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String values{get;set;}
    }
    /**Fetch account for lightning map */

    @AuraEnabled(cacheable=true)
    public static List<Account> fetchAccforMapAccountId(String recordId){
        List<Account> acc = [SELECT Id, Name, ShippingStreet, ShippingCity, ShippingState, 
                                    ShippingPostalCode, ShippingCountry, ShippingLatitude, ShippingLongitude 
                                    FROM Account WHERE Id=: recordId];
        System.debug('XXX Fetch Account for map == > '+acc);
        If(acc.size()>0){
            return acc;
        }else{
            return null;
        }

    }
    /*
    @AuraEnabled
    public static List<String> getObjectName(){
        try {
            Map<String, Schema.SObjectType> AllObjectMap = new Map<String, Schema.SObjectType>();
            AllObjectMap = Schema.getGlobalDescribe();
            List<String> l = new List<String>(AllObjectMap.keyset());
            System.debug('values == > '+l+' size : '+l.size());
            return l;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getPickListValuesForDescribe(String sObjectname, String sFieldName){
        try {
            List<String> picklistValueList = new List<String>();
            Map<String, String> newMap = new Map<String, String>();
            Schema.sObjectType convertToObj = Schema.getGlobalDescribe().get(sObjectName);
            Schema.DescribeSObjectResult res = convertToObj.getDescribe();
            Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(sFieldName).getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            for(Schema.PicklistEntry picklistval : ple){
                picklistValueList.add(picklistval.getLabel());
                System.debug('Get Picklist Value List : Label : '+picklistval.getLabel()+' : picklist values : '+picklistval.getValue());
            }
            System.debug('XXX get pick list values list == > '+picklistValueList);
            return picklistValueList;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getPickListValuesForTask(){
        try {
            List<String> Task_Picklist_Type = tabAccountAddressLWCController.getPickListValuesForDescribe('Task', 'Status');
            System.debug('XXX return picklist value for Task == > Status == > '+Task_Picklist_Type);
            return Task_Picklist_Type;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    */
}