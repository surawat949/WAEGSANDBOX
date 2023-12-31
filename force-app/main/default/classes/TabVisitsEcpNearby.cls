public with sharing class TabVisitsEcpNearby {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsMap(String recordId, Double distance, String SegmentationBox, Double PotentialMin, Double PotentialMax, String FirstLocalCampetitor, String svsnetwork){
        try {

            System.debug('First local competitor '+FirstLocalCampetitor);
            List<Account> result = new List<Account>();
            if(PotentialMin == null){PotentialMin=0;}
            if(PotentialMax == null){PotentialMax=999999999;}

            List<Id> getRecId = new List<Id>();

            String RecChainRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Chain').getRecordTypeId();
            System.debug('Account Chain RecordType is =>'+RecChainRT);

            String RecIndRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
            System.debug('Account Independent RecordType is => '+RecIndRT);

            String RecChainSeikoRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Chain_Seiko').getRecordTypeId();
            System.debug('Account Chain Seiko RecordType is => '+RecChainSeikoRT);

            String RecIndSeikoRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Seiko_Independent').getRecordTypeId();
            System.debug('Account Independent Seiko RecordType is =>'+RecIndSeikoRT);

            getRecId.add(RecChainRT);
            getRecId.add(RecIndRT);
            getRecId.add(RecChainSeikoRT);
            getRecId.add(RecIndSeikoRT);
            System.debug('List for Record Type => '+getRecId);

            String critSegmentation = '';
            String critFstCompetitor = '';
            String critSvsNetwork = '';

            if(SegmentationBox!=null && SegmentationBox!=''){
                critSegmentation = ' and Segmentation_Box__c LIKE \'%'+SegmentationBox+'%\' ';
            }

            if(FirstLocalCampetitor!=null && FirstLocalCampetitor!=''){
                critFstCompetitor = ' and First_Competitor_local_name__c LIKE \'%'+FirstLocalCampetitor+'%\' ';
            }

            if(svsnetwork!=null && svsnetwork!=''){
                critSvsNetwork = ' and Seiko_Network__c LIKE \'%'+svsnetwork+'%\' ';
            }

            Account acc = [SELECT Id, Hoya_Account_ID__c, Name, ShippingStreet, ShippingCity, ShippingState,
                                ShippingPostalCode, ShippingCountry, Segmentation_Box__c, ShippingLatitude, ShippingLongitude, 
                                First_Competitor_local_name__c, Seiko_Network__c, Brand__c FROM Account
                                WHERE Id=:recordId];
            result.add(acc);

            Double latitude = acc.ShippingLatitude;
            Double longitude = acc.ShippingLongitude;
            String accId = acc.Hoya_Account_ID__c;

            if(acc.ShippingLatitude==null){latitude = 0;}
            if(acc.ShippingLongitude==null){longitude = 0;}

            String soql = 'SELECT Id, Hoya_Account_ID__c, Name, Segmentation_Box__c, First_Competitor_local_name__c, '
                            +'ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, '
                            +'ShippingLongitude, ShippingLatitude, Brand__c FROM Account WHERE RecordTypeId IN: getRecId '
                            +'AND Potential__c>='+PotentialMin.longValue()+' AND Potential__c<='+PotentialMax.longValue()+' AND '
                            +'DISTANCE(ShippingAddress, GEOLOCATION('+latitude+', '+longitude+'), \'km\')<'+distance +
                            critSegmentation + critFstCompetitor + critSvsNetwork + ' AND Hoya_Account_ID__c != \''+accId+'\' ORDER BY Name ASC LIMIT 500';
            System.debug('SOQL => '+soql);

            List<Account> aList = database.query(soql);
            result.addAll(aList);

            System.debug('Found Account Nearby => '+result.size()+' | There is the list => '+result);

            return result;
            
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getCompetitorPicklistVal(){
        try {
            Schema.DescribeFieldResult fieldResult = Account.First_Competitor_local_name__c.getDescribe();
            List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
            List<optionSet> dataset = new List<optionSet>();
            for(Schema.PicklistEntry picklistval : pEntry){
                String pListLabelName = picklistval.getLabel();
                String pListValue = picklistval.getValue();

                dataset.add(new optionSet(pListLabelName, pListValue));

            }
            //System.debug('XXX Get Picklist value, Clinic Type =>'+dataset);
            return dataset;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getSVSNetworkPicklistVal(){
        try {
            Schema.DescribeFieldResult fieldResult = Account.Seiko_Network__c.getDescribe();
            List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
            List<optionSet> dataset = new List<optionSet>();
            for(Schema.PicklistEntry picklistval : pEntry){
                String pListLabelName = picklistval.getLabel();
                String pListValue = picklistval.getValue();

                dataset.add(new optionSet(pListLabelName, pListValue));

            }
            //System.debug('XXX Get Picklist value, Clinic Type =>'+dataset);
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

    @AuraEnabled(cacheable=true)
    public static sObject searchFirstCompetitorDefault(String recordId, String sObjectApiName){
        String recId = recordId;
        String sQuery = 'select Id, DurableId, label, value from picklistvalueinfo where ' +
                        'entityparticle.entitydefinition.qualifiedapiname = \''+sObjectApiName+'\' '+
                        'and entityparticle.developername = \'First_Competitor_local_name\' '+
                        'and isactive = true and value LIKE :recId order by value asc limit 1';
        for(sObject obj : database.query(sQuery)){
            return obj;
        }

        return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> searchFirstCompetitor(String searchKey, String sObjectApiName){
        List<sObject> returnList = new List<sObject>();
        String swildcardSearch = searchKey;

        if(String.isNotBlank(searchKey)){
            swildcardSearch = '%'+searchKey+'%';
            String sQuery = 'select Id, DurableId, label, value from picklistvalueinfo where ' +
                        'entityparticle.entitydefinition.qualifiedapiname = \''+sObjectApiName+'\' '+
                        'and entityparticle.developername = \'First_Competitor_local_name\' and isactive = true '+
                        'and value LIKE: swildcardSearch order by value asc';
            for(sObject obj : database.query(sQuery)){
                returnList.add(obj);
            }
        }else{
            swildcardSearch = '';
        }

        return returnList;
    }
}