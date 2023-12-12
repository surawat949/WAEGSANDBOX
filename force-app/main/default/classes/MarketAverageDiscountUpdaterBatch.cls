/*****************************************************************************************************
* Name            :  MarketAverageDiscountUpdaterBatch
* Description     :  Batch Class to be used to update the Market Average Discount on Independent Account for Last 12 Months per Country.
				     This Batch should be every month
                     String cronexpression = '0 00 08,20 * * ?';
                     System.schedule('Average Discount Updater Schedule Job', cronexpression, new MarketAverageDiscountUpdaterBatch());					
* Usage           :  MarketAverageDiscountUpdaterBatch                                                          
* Created By      :  Encora                                                     
*****************************************************************************************************/

public class MarketAverageDiscountUpdaterBatch implements Database.Batchable<SObject>, Schedulable { 
   
    public MarketAverageDiscountUpdaterBatch() {}   
    // Start method will return a row per country maximum 22 Countries data as of now in production
    public Iterable<AggregateResult> start(Database.BatchableContext context){ 
       return [SELECT Sum(Lenses_Net_Sales_Last_12Mo__c) netSalesSum,Sum(Lenses_Gross_Sales_Last_12Mo__c) grossSalesSum,Account__r.Owner.CompanyName FROM Last_Sales_Statistics__c 
               WHERE Account__r.Channel__c ='Independent' AND Account__r.Lenses_Net_Sales_Last_12Mo__c > 0
               GROUP BY Account__r.Owner.CompanyName];
    }
    public void execute(Database.BatchableContext context, List<sObject> scope) {
        try {
            List<Account> accUpdateLst = new List<Account>();
            Map<String,Sales> netAndGrossSalesMap = new Map<String,Sales>();  
            if(scope.size() > 0){
                for(sObject sObj : scope) {
                    AggregateResult ag = (AggregateResult)sObj;
                    Sales sale =new Sales();
                    sale.netSales = (Double) ag.get('netSalesSum');
                    sale.grossSales = (Double) ag.get('grossSalesSum');
                    netAndGrossSalesMap.put((String)ag.get('CompanyName'),sale);
                }
            }
            if(netAndGrossSalesMap.size() > 0){
                for(String company :netAndGrossSalesMap.keySet()){
                    List<Account> accounts = [SELECT Id,Market_Avg_Disc_Ind_L12M__c,Owner.CompanyName from Account where Owner.CompanyName =: company
                                              AND Channel__c ='Independent'  
                                              AND Lenses_Net_Sales_Last_12Mo__c > 0];
                    System.debug(company+'--'+accounts.size());
                    for(Account acc:accounts){
                         if(netAndGrossSalesMap.containskey(acc.Owner.CompanyName)){
                            Sales sale =  netAndGrossSalesMap.get(acc.Owner.CompanyName);
                            Decimal discount = ((sale.netSales - sale.grossSales)/sale.grossSales)*100;
                            acc.Market_Avg_Disc_Ind_L12M__c = discount.setScale(2);
                            accUpdateLst.add(acc);
                            //Account update will be done for each country
                            if(accUpdateLst.size() > 0)
                				update accUpdateLst;
                    	 }
                    }
                } 
            }
        } catch (Exception ex) {
            LogException.log(ex);
        }
    }     
    public void execute(SchedulableContext ctx) {
        MarketAverageDiscountUpdaterBatch thisBatch = new MarketAverageDiscountUpdaterBatch();
        Database.executeBatch(thisBatch);
    }
    public void finish(Database.BatchableContext context){ }
    
    public class Sales{
        public Decimal netSales{get;set;}
        public Decimal grossSales{get;set;}
    }
}