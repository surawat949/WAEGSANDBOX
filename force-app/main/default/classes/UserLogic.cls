/*
*   UserLogic Class
*       Class where you can put all the logic from the trigger handler  
*/
public with sharing class UserLogic {

    public static void sendEmailHandler(List<User> newObjects,Map<Id, User> oldObjectsMap) {
        system.debug('### Trigger  '+ newObjects);
        Set<Id> userID = new Set<Id>();
        for(User usr : newObjects){
            if(usr.ContactId != null)
                userID.add(usr.Id);
        }
        Map<String,Assign_default_permissions__mdt> mapCommunicationEmail = new Map<String,Assign_default_permissions__mdt>();
        for(Assign_default_permissions__mdt comm : [SELECT Id, Account_Portal__c,From_Email_Address__c FROM Assign_default_permissions__mdt]){
            mapCommunicationEmail.put(comm.Account_Portal__c,comm);
        }
        Map<Id, User> userMap = new Map<Id, User>([SELECT id, Profile.Name,Reset_Password_Token__c,Reset_Password_Context__c,ContactId,
                                                            Contact.Created_on_portal__c,Contact.Contact_Record_Type__c,  
                                                            Contact.Account_Portal__c, Contact.Invite_Portal_Email__c, Contact_Language__c
                                                    FROM User WHERE Id in :userID AND isActive = true
                                                    AND Profile.Name like 'Customer Community Plus User%']);
        //  Create a master list to hold the emails
        List<Messaging.SingleEmailMessage> list_mails =  new List<Messaging.SingleEmailMessage>();   
  
        for(User usr : userMap.values()){
            Boolean shoulAddEmail = false;
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
            // EMAIL: send reset password
            //      Template Name: Reset_Password
            if(usr.Reset_Password_Token__c != oldObjectsMap.get(usr.Id).Reset_Password_Token__c && usr.Reset_Password_Token__c != null){
                System.debug('#### Send Reset Password');
                String template = usr.Contact.Account_Portal__c !='Seiko Pro' ? 'Reset_Password': 'SEIKO_Password_reset';
                if(usr.Contact.Account_Portal__c!=null && usr.Contact.Account_Portal__c.contains('seiko')){
                    template = 'SEIKO_Password_reset';
                }else if(usr.Contact.Invite_Portal_Email__c.contains('Contact Lenses')){
                    template = 'Contact_Lenses_Reset_Password';
                }//Mohan added
                else if(usr.Contact.Invite_Portal_Email__c.contains('Costco')){
                    template = 'COSTCO_Password_reset';
                }

                mail = Utility.buildMailMessage(template, usr.Id, usr.Contact.Account_Portal__c != null ? mapCommunicationEmail.get(usr.Contact.Account_Portal__c).From_Email_Address__c : mapCommunicationEmail.get('usportal').From_Email_Address__c);
                shoulAddEmail = true;
            }
            // EMAIL: Reset Password confirmation
            //      Template Name: Reset_Password_Confirmation
            if(usr.Reset_Password_Context__c == 'PasswordReset' && usr.Reset_Password_Token__c == null && oldObjectsMap.get(usr.Id).Reset_Password_Token__c != null){
                System.debug('#### Send Reset Password Confirmation');
                String template = usr.Contact.Account_Portal__c !='Seiko Pro' ? 'Reset_Password_Confirmation': 'SEIKO_Password_has_been_reset';
                if(usr.Contact.Account_Portal__c!=null && usr.Contact.Account_Portal__c.contains('seiko')){
                    template = 'SEIKO_Password_has_been_reset';
                }else if(usr.Contact.Invite_Portal_Email__c.contains('Contact Lenses')){
                    template = 'Contact_Lenses_Reset_Password_Confirm';
                }
                mail = Utility.buildMailMessage(template, usr.Id, usr.Contact.Account_Portal__c != null ? mapCommunicationEmail.get(usr.Contact.Account_Portal__c).From_Email_Address__c : mapCommunicationEmail.get('usportal').From_Email_Address__c);
                shoulAddEmail = true;
            }
            // EMAIL: new employee confirmation
            //      Template Name: Portal_New_Employee_Confirmation
            if(usr.Reset_Password_Context__c == 'NewEmployee' && usr.Reset_Password_Token__c == null && oldObjectsMap.get(usr.Id).Reset_Password_Token__c != null){
                System.debug('#### New Employee Confirmation');
                String template = usr.Contact.Account_Portal__c !='Seiko Pro' ? 'Portal_New_Employee_Confirmation': 'SEIKO_Registration_confirmation_employee';
                if(usr.Contact.Account_Portal__c!=null && usr.Contact.Account_Portal__c.contains('seiko')){
                    template = 'SEIKO_Registration_confirmation_employee';
                }else if(usr.Contact.Invite_Portal_Email__c.contains('Contact Lenses')){
                    template = 'CL_Registration_Confirmation';//'Contact_Lenses_Reset_Password_Confirm';
                }
                mail = Utility.buildMailMessage(template, usr.Id, usr.Contact.Account_Portal__c != null ? mapCommunicationEmail.get(usr.Contact.Account_Portal__c).From_Email_Address__c : mapCommunicationEmail.get('usportal').From_Email_Address__c);
                shoulAddEmail = true;
            }
            // EMAIL: Portal registration welcome
            //      Template Name: Registration_Confirmation
            /*if(usr.Profile.Name == 'Customer Community Plus User' && usr.Contact.Contact_Record_Type__c == 'Shop Owner' && !usr.Contact.Created_on_portal__c){
                System.debug('#### Portal Registration Confirmation');
                mail = Utility.buildMailMessage('Registration_Confirmation', usr.Id, mapCommunicationEmail.get(usr.Contact.Account_Portal__c).From_Email_Address__c);
            }*/
            if(shoulAddEmail)
                list_mails.add(mail);
        }
        system.debug('#### list '+ list_mails);
        if(list_mails.size() > 0)
            Messaging.sendEmail(list_mails);
    }

    public static void sendEmailHandlerAfterInsert(List<User> newObjects,Map<Id, User> newObjectsMap) {
        system.debug('### Trigger after inser '+ newObjects);
        Set<Id> userID = new Set<Id>();
        for(User usr : newObjects){
            if(usr.ContactId != null)
                userID.add(usr.Id);
        }
        Map<String,Assign_default_permissions__mdt> mapCommunicationEmail = new Map<String,Assign_default_permissions__mdt>();
        for(Assign_default_permissions__mdt comm : [SELECT Id, Account_Portal__c,From_Email_Address__c FROM Assign_default_permissions__mdt]){
            mapCommunicationEmail.put(comm.Account_Portal__c,comm);
        }
        Map<Id, User> userMap = new Map<Id, User>([SELECT id, Profile.Name,Reset_Password_Token__c,Reset_Password_Context__c, Username, ContactId,
                                                            Contact.Created_on_portal__c,Contact.Contact_Record_Type__c, 
                                                            Contact.Account_Portal__c, Contact.Invite_Portal_Email__c, Contact_Language__c
                                                    FROM User WHERE Id in :userID]);
        //  Create a master list to hold the emails
        List<Messaging.SingleEmailMessage> list_mails =  new List<Messaging.SingleEmailMessage>();   
  
        for(User usr : userMap.values()){
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
            //EMAIL: Portal registration welcome
            //      Template Name: Registration_Confirmation
            if((usr.Profile.Name == 'Customer Community Plus User'||usr.Profile.Name == 'Customer Community Plus User + API') && usr.Contact.Contact_Record_Type__c == 'Shop Owner' && !usr.Contact.Created_on_portal__c){
                System.debug('#### Portal Registration Confirmation');
                System.debug('usr.Contact.Invite_Portal_Email__c='+usr.Contact.Invite_Portal_Email__c);
                String template;
                if(usr.Contact.Account_Portal__c!=null && usr.Contact.Account_Portal__c.contains('seiko')){
                    template = 'SEIKO_Registration_confirmation'; 
                }else if(usr.Contact.Invite_Portal_Email__c == 'VA, HLC & Hoya Hub'){
                    template = 'VA_Portal_New_Employee_Confirmation';
                }
                //Canada Hub -- Employee confirmation start
                else if(usr.Contact.Invite_Portal_Email__c == 'VI, HLC, Hoya Hub'){
                    template = 'VI_New_Employee_Confirmation';
                }
                 //Canada Hub -- Employee confirmation End
                 
                 //Costco Portal -- Employee confirmation start
                else if(usr.Contact.Invite_Portal_Email__c == 'Costco Portal'){
                    template = 'Costco_New_Employee_Confirmation';
                }
                 //Costco Portal -- Employee confirmation End
                else if(usr.Contact.Invite_Portal_Email__c == 'HOYA Contact Lenses'){
                    template = 'CL_Registration_Confirmation';
                }else if(usr.Contact.Invite_Portal_Email__c == 'HHP Canada'){
                    
                   /* if (usr.Contact_Language__c == 'fr-ca' || usr.Contact_Language__c == 'fr-fr')
                         template = 'Shop_owner_reg_confirmation_email_HHP_Fr';
                    else*/
                    /* CDU 26/08/2021: language is now a parameter in template call, template is now using custom labels */
                        template = 'Shop_owner_reg_confirmation_email_HHP';
                }
                else{
                    template = 'Registration_Confirmation';
                }
                
                mail = Utility.buildMailMessage(template, usr.Id, usr.Contact.Account_Portal__c != null ? mapCommunicationEmail.get(usr.Contact.Account_Portal__c).From_Email_Address__c : mapCommunicationEmail.get('usportal').From_Email_Address__c);
                list_mails.add(mail);
            }
            //EMAIL: send registration for employee - reset passowrd to employee
            //      Template Name: Portal_Reg_Employee_Confirmation
            // Employee registration mail. 
            if(usr.Contact.Created_on_portal__c && usr.ContactId != null){
                System.debug('#### Send Reset Password to Employee');
                String template;
                if(usr.Contact.Account_Portal__c =='Seiko Pro'){
                    template = 'SEIKO_Invitation_Email_Employees';
                }else if(usr.Contact.Invite_Portal_Email__c == 'HOYA Contact Lenses'){
                    template = 'Contact_Lenses_employee_registration';
                }else{
                    template = 'Portal_Reg_Employee_Confirmation';
                }

                if(usr.Contact.Account_Portal__c!=null && usr.Contact.Account_Portal__c.contains('seiko')){
                    template = 'SEIKO_Invitation_Email_Employees';
                }
                mail = Utility.buildMailMessage(template, usr.Id, usr.Contact.Account_Portal__c != null ? mapCommunicationEmail.get(usr.Contact.Account_Portal__c).From_Email_Address__c : mapCommunicationEmail.get('usportal').From_Email_Address__c);
                list_mails.add(mail);
            }
        }
        if(list_mails.size() > 0)
            Messaging.sendEmail(list_mails);
    }

    public static void updateContactWithCommunityNickName(List<User> newObjects,Map<Id, User> newObjectsMap){
        List<Contact> contactList = new List<Contact>();
        for(User user: newObjects){
            if(user.contactId!=null){
                Contact c = new Contact();
                c.Id = user.contactId;
                c.Portal_User_Name__c = User.CommunityNickname;
                contactList.add(c);
            }
        }
        if(!contactList.isEmpty()){
            update contactList;
        }
    }
    
}