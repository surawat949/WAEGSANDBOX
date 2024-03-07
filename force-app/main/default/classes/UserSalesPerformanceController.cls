public class UserSalesPerformanceController {
    public Budget_by_ASM__c budget{get;set;}
    public Budget_by_ASM__c teamBudget{get;set;}
    public List<Budget_by_ASM__c> teamBudgetList;
    //Constructor
    public UserSalesPerformanceController(){
        
        budget = null;
        teamBudget = null;
        teamBudgetList = new List<Budget_by_ASM__c>();
        Map<String, Decimal> averages = new Map<String, Decimal>();
        Integer nbRecord = [select count() from Budget_by_ASM__c where Lookupuser__c=:UserInfo.getUserId()];
        String currentUserId = UserInfo.getUserId();
        List<User> usersBelowCurrentRole = getUsersBelowRole(currentUserId);
        
        if(nbRecord==1){
            budget = [select 
                      LocalSales1CY__c, LocalSales2CY__c, LocalSales3CY__c, LocalSales4CY__c, LocalSales5CY__c, LocalSales6CY__c, LocalSales7CY__c, LocalSales8CY__c, LocalSales9CY__c, LocalSales10CY__c, LocalSales11CY__c, LocalSales12CY__c,Local_Sales_YTD__c,
                      LocalSales1LY__c, LocalSales2LY__c, LocalSales3LY__c, LocalSales4LY__c, LocalSales5LY__c, LocalSales6LY__c, LocalSales7LY__c, LocalSales8LY__c, LocalSales9LY__c, LocalSales10LY__c, LocalSales11LY__c, LocalSales12LY__c
                      ,Sales_Apr_vsLY__c, Sales_May_vsLY__c, Sales_Jun_vsLY__c, Sales_Jul_vsLY__c, Sales_Aug_vsLY__c, Sales_Sep_vsLY__c, Sales_Oct_vsLY__c, Sales_Nov_vsLY__c, Sales_Dec_vsLY__c, 
                      Quota1CY__c, Quota2CY__c, Quota3CY__c, Quota4CY__c, Quota5CY__c, Quota6CY__c, Quota7CY__c, Quota8CY__c, Quota9CY__c, Quota10CY__c, Quota11CY__c, Quota12CY__c, Sales_Jan_vsLY__c, Sales_Feb_vsLY__c, Sales_Mar_vsLY__c, Sales_YTD_vsLY__c,
                      Quota_Ach_April__c, Quota_Ach_May__c, Quota_Ach_June__c, Quota_Ach_July__c, Quota_Ach_August__c, Quota_Ach_September__c, Quota_Ach_October__c, Quota_Ach_November__c, Quota_Ach_December__c, Quota_Ach_January__c, Quota_Ach_February__c, Quota_Ach_March__c,Quota_YTD__c,Quota_Ach_YTD__c,
                      Local_Sales_LY_YTD__c
                      from Budget_by_ASM__c
                      where Lookupuser__c=:UserInfo.getUserId()];
            teamBudgetList = [select 
                          LocalSales1CY__c, LocalSales2CY__c, LocalSales3CY__c, LocalSales4CY__c, LocalSales5CY__c, LocalSales6CY__c, LocalSales7CY__c, LocalSales8CY__c, LocalSales9CY__c, LocalSales10CY__c, LocalSales11CY__c, LocalSales12CY__c,Local_Sales_YTD__c,
                          LocalSales1LY__c, LocalSales2LY__c, LocalSales3LY__c, LocalSales4LY__c, LocalSales5LY__c, LocalSales6LY__c, LocalSales7LY__c, LocalSales8LY__c, LocalSales9LY__c, LocalSales10LY__c, LocalSales11LY__c, LocalSales12LY__c
                          ,Sales_Apr_vsLY__c, Sales_May_vsLY__c, Sales_Jun_vsLY__c, Sales_Jul_vsLY__c, Sales_Aug_vsLY__c, Sales_Sep_vsLY__c, Sales_Oct_vsLY__c, Sales_Nov_vsLY__c, Sales_Dec_vsLY__c, 
                          Quota1CY__c, Quota2CY__c, Quota3CY__c, Quota4CY__c, Quota5CY__c, Quota6CY__c, Quota7CY__c, Quota8CY__c, Quota9CY__c, Quota10CY__c, Quota11CY__c, Quota12CY__c, Sales_Jan_vsLY__c, Sales_Feb_vsLY__c, Sales_Mar_vsLY__c, Sales_YTD_vsLY__c,
                          Quota_Ach_April__c, Quota_Ach_May__c, Quota_Ach_June__c, Quota_Ach_July__c, Quota_Ach_August__c, Quota_Ach_September__c, Quota_Ach_October__c, Quota_Ach_November__c, Quota_Ach_December__c, Quota_Ach_January__c, Quota_Ach_February__c, Quota_Ach_March__c,Quota_YTD__c,Quota_Ach_YTD__c,
                          Local_Sales_LY_YTD__c
                          from Budget_by_ASM__c
                          where Lookupuser__c IN :usersBelowCurrentRole];
            for (Budget_by_ASM__c record : teamBudgetList) {
                for (String fieldName : sums.keySet()) {
                    Decimal value = (Decimal)record.get(fieldName);
                    sums.put(fieldName, sums.get(fieldName) + value);
                    counts.put(fieldName, counts.get(fieldName) + 1);
                }
            }
            for (String fieldName : sums.keySet()) {
                averages.put(fieldName, sums.get(fieldName) / counts.get(fieldName));
            }
            
            System.debug('teamBudget '+teamBudget);
        }
    }
    
    public static List<User> getUsersBelowRole(String currentUserId) {
        List<User> usersBelowRole = new List<User>();
        User userData = [SELECT UserRoleId FROM User WHERE Id = :currentUserId];
        UserRole currentUserRole = [SELECT Id FROM UserRole WHERE Id = :userData.UserRoleId ];
        List<UserRole> rolesBelow = [SELECT Id FROM UserRole WHERE ParentRoleId = :currentUserRole.Id];
        system.debug('Child roles '+rolesBelow);
        for (UserRole role : rolesBelow) {
            List<User> users = [SELECT Id, Name, Email FROM User WHERE UserRoleId = :role.Id];
            usersBelowRole.addAll(users);
        }
        system.debug('Child User '+usersBelowRole.size());
        return usersBelowRole;
    }
    public static Budget_by_ASM__c calculateAverage(Budget_by_ASM__c teamBudget) {
        Budget_by_ASM__c teamBudgetData;
        return teamBudgetData;
    }
    Map<String, Decimal> sums = new Map<String, Decimal>{
        'Sales_Jan_vsLY__c' => 0,
        'Sales_Feb_vsLY__c' => 0,
        'Sales_Mar_vsLY__c' => 0,
        'Sales_Apr_vsLY__c' => 0,
        'Sales_May_vsLY__c' => 0,
        'Sales_Jun_vsLY__c' => 0,
        'Sales_Jul_vsLY__c' => 0,
        'Sales_Aug_vsLY__c' => 0,
        'Sales_Sep_vsLY__c' => 0,
        'Sales_Oct_vsLY__c' => 0,
        'Sales_Nov_vsLY__c' => 0,
        'Sales_Dec_vsLY__c' => 0,
        'Sales_Mar_vsLY__c' => 0,
        'Sales_YTD_vsLY__c' => 0,
        'Quota_Ach_January__c' => 0,
        'Quota_Ach_February__c' => 0,
        'Quota_Ach_March__c' => 0,
        'Quota_Ach_April__c' => 0,
        'Quota_Ach_May__c' => 0,
        'Quota_Ach_June__c' => 0,
        'Quota_Ach_July__c' => 0,
        'Quota_Ach_August__c' => 0,
        'Quota_Ach_September__c' => 0,
        'Quota_Ach_October__c' => 0,
        'Quota_Ach_November__c' => 0,
        'Quota_Ach_December__c' => 0,
        'Quota_YTD__c' => 0,
        'Quota_Ach_YTD__c' => 0,
        'Quota1CY__c' => 0,
        'Quota2CY__c' => 0,
        'Quota3CY__c' => 0,
        'Quota4CY__c' => 0,
        'Quota5CY__c' => 0,
        'Quota6CY__c' => 0,
        'Quota7CY__c' => 0,
        'Quota8CY__c' => 0,
        'Quota9CY__c' => 0,
        'Quota10CY__c' => 0,
        'Quota11CY__c' => 0,
        'Quota12CY__c' => 0,
        'LocalSales1CY__c' => 0,
        'LocalSales2CY__c' => 0,
        'LocalSales3CY__c' => 0,
        'LocalSales4CY__c' => 0,
        'LocalSales5CY__c' => 0,
        'LocalSales6CY__c' => 0,
        'LocalSales7CY__c' => 0,
        'LocalSales8CY__c' => 0,
        'LocalSales9CY__c' => 0,
        'LocalSales10CY__c' => 0,
        'LocalSales11CY__c' => 0,
        'LocalSales12CY__c' => 0,
        'Local_Sales_YTD__c' => 0,
        'LocalSales1LY__c' => 0,
        'LocalSales2LY__c' => 0,
        'LocalSales3LY__c' => 0,
        'LocalSales4LY__c' => 0,
        'LocalSales5LY__c' => 0,
        'LocalSales6LY__c' => 0,
        'LocalSales7LY__c' => 0,
        'LocalSales8LY__c' => 0,
        'LocalSales9LY__c' => 0,
        'LocalSales10LY__c' => 0,
        'LocalSales11LY__c' => 0,
        'LocalSales12LY__c' => 0
    };
    Map<String, Decimal> counts = new Map<String, Decimal>{
        'Sales_Jan_vsLY__c' => 0,
        'Sales_Feb_vsLY__c' => 0,
        'Sales_Mar_vsLY__c' => 0,
        'Sales_Apr_vsLY__c' => 0,
        'Sales_May_vsLY__c' => 0,
        'Sales_Jun_vsLY__c' => 0,
        'Sales_Jul_vsLY__c' => 0,
        'Sales_Aug_vsLY__c' => 0,
        'Sales_Sep_vsLY__c' => 0,
        'Sales_Oct_vsLY__c' => 0,
        'Sales_Nov_vsLY__c' => 0,
        'Sales_Dec_vsLY__c' => 0,
        'Sales_Mar_vsLY__c' => 0,
        'Sales_YTD_vsLY__c' => 0,
        'Quota_Ach_January__c' => 0,
        'Quota_Ach_February__c' => 0,
        'Quota_Ach_March__c' => 0,
        'Quota_Ach_April__c' => 0,
        'Quota_Ach_May__c' => 0,
        'Quota_Ach_June__c' => 0,
        'Quota_Ach_July__c' => 0,
        'Quota_Ach_August__c' => 0,
        'Quota_Ach_September__c' => 0,
        'Quota_Ach_October__c' => 0,
        'Quota_Ach_November__c' => 0,
        'Quota_Ach_December__c' => 0,
        'Quota_YTD__c' => 0,
        'Quota_Ach_YTD__c' => 0,
        'Quota1CY__c' => 0,
        'Quota2CY__c' => 0,
        'Quota3CY__c' => 0,
        'Quota4CY__c' => 0,
        'Quota5CY__c' => 0,
        'Quota6CY__c' => 0,
        'Quota7CY__c' => 0,
        'Quota8CY__c' => 0,
        'Quota9CY__c' => 0,
        'Quota10CY__c' => 0,
        'Quota11CY__c' => 0,
        'Quota12CY__c' => 0,
        'LocalSales1CY__c' => 0,
        'LocalSales2CY__c' => 0,
        'LocalSales3CY__c' => 0,
        'LocalSales4CY__c' => 0,
        'LocalSales5CY__c' => 0,
        'LocalSales6CY__c' => 0,
        'LocalSales7CY__c' => 0,
        'LocalSales8CY__c' => 0,
        'LocalSales9CY__c' => 0,
        'LocalSales10CY__c' => 0,
        'LocalSales11CY__c' => 0,
        'LocalSales12CY__c' => 0,
        'Local_Sales_YTD__c' => 0,
        'LocalSales1LY__c' => 0,
        'LocalSales2LY__c' => 0,
        'LocalSales3LY__c' => 0,
        'LocalSales4LY__c' => 0,
        'LocalSales5LY__c' => 0,
        'LocalSales6LY__c' => 0,
        'LocalSales7LY__c' => 0,
        'LocalSales8LY__c' => 0,
        'LocalSales9LY__c' => 0,
        'LocalSales10LY__c' => 0,
        'LocalSales11LY__c' => 0,
        'LocalSales12LY__c' => 0
    };
}