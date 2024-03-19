public class VisitTriggerHelper {
     public static void entry(
        System.TriggerOperation triggerEvent,
        List <Visits__c> newList,
        Map <Id, Visits__c> newMap,
        List <Visits__c> oldList,
        Map <Id, Visits__c> oldMap
    ) {
        if(triggerEvent == System.TriggerOperation.BEFORE_INSERT ){
            Set<Id> accountIdsLst = new Set<Id>();
            if(newList != null && newList.size() > 0){
                for(Visits__c visit : newList){
                    accountIdsLst.add(visit.Account__c);
                }
        	} 
           updateVisitHomeOfficeTracker(newList,accountIdsLst);
        }
    }
    public static void updateVisitHomeOfficeTracker(List<Visits__c> newList,Set<Id> accountIdsLst){
        List<Visits__c> visitUpdateLst = new List<Visits__c>();
        //collect all the country codes and pass them to the query   
         Map<Id,String> shopCountryMap = new Map<Id,String>();
         Date creationDate = Date.today();
         Datetime dt = (DateTime)creationDate;
         String dayOfWeek = dt.format('EEEE');        
         if(accountIdsLst.size() > 0){
            List<Account> accLst =[select Id,Shop_Country__c from Account where Id in :accountIdsLst];
            if(accLst.size() > 0){
                for(Account acc:accLst){
                    shopCountryMap.put(acc.Id,acc.Shop_Country__c);
                }               
            } 
         }
        Map<String,String> homeOfficeDayMap = new Map<String,String>();
        Map<String, Entity_detail__mdt> allMetadadata = Entity_detail__mdt.getAll();
        for (Entity_detail__mdt entity : allMetadadata.values()) {
            homeOfficeDayMap.put(entity.Country_Code__c,entity.ASM_Home_Office_Day__c);
        }            
        //Compare the creationday of visit with home office day
        if(shopCountryMap.size() > 0){
            for(Visits__c visit:newList){
                String shopCountry = shopCountryMap.get(visit.Account__c);
                if(shopCountry != null && homeOfficeDayMap.size() > 0  && homeOfficeDayMap.containsKey(shopCountry)){
                    if(homeOfficeDayMap.get(shopCountry) == 'No Instrution' || homeOfficeDayMap.get(shopCountry) == null){
                        visit.Visit_Home_Office_Tracker__c = 'Free Organization';
                    }
                    else if(dayOfWeek == homeOfficeDayMap.get(shopCountry)){                        
                        visit.Visit_Home_Office_Tracker__c = 'Home Office Day';
                    }
                    else{
                        visit.Visit_Home_Office_Tracker__c = 'Other Days';
                    }
                }
                else{//If Shop country is not there in Meta Data
                    visit.Visit_Home_Office_Tracker__c = 'Free Organization';
                }
            }
        }
    }
}