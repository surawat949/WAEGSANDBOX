public with sharing class TabMVCVisitsTacticomController {
    
    //method to get the Contact visit frequenct details - AZURE 741
    @AuraEnabled(cacheable=true)
    public static Contact getContactVisitFrequency(Id contactId){
        Contact con =[Select id,Last_contact_visit_date__c,Contact_Digital_Visits_Frequency__c,Contact_Digital_Visits_Performed__c,Contact_Digital_Visits_Planned__c,
                      Contact_Direct_Visits_Planned__c,Total_Visits_Planned__c,Contact_Direct_Visits_Frequency__c,
                      Total_Visit_Achieved__c,Last_Digital_Visit_Date__c from Contact where id=:contactId limit 1];
        return con;
    }
    
    
    //method to get the tacticom details - AZURE 742
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getAccountsByZone(String conOwner){
        List<AggregateResult> result =  [Select SUM(Total_Visits_Per_Year__c ) cnt,TACTICOM_SOF__c from Account 
                                         where TACTICOM_SOF__c !=null AND ownerId=:conOwner group by TACTICOM_SOF__c ];
        return result;
    }
    
}