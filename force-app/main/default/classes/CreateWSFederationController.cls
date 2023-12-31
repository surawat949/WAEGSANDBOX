public with sharing class CreateWSFederationController{
    
    public WS_Federation_Realm__c realm { get; private set; }

    public CreateWSFederationController() {
        realm = new WS_Federation_Realm__c();
    }
    
    public PageReference save() {
        try {
            insert(realm);
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        //  After Save, navigate to the default view page:
        return new PageReference('/apex/WSFederationManagement');
    }
    
}