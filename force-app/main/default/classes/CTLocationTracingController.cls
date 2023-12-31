public with sharing class CTLocationTracingController {
    public static List<Location_Tracing__c> getVisitors(String locationId) {
        return [SELECT Id, Person__c, Location__c, Visit_Date__c, Person__r.Name, Person__r.Token__c, Person__r.Health_Status__c 
            FROM Location_Tracing__c
            WHERE Id =: locationId 
            ORDER BY Visit_Date__c DESC];
    }

    public static List<Location_Tracing__c> getLocationsByPersonsIds(Set<Id> personIds) {
        return [SELECT Id, Person__c, Location__c 
            FROM Location_Tracing__c
            WHERE Person__c IN :personIds
            AND Visit_Date__c = LAST_N_DAYS:10];
    
         }
     
     /**
      * Get all visitors Ids for locations
      *@param locationIds
      *@return List<Location_Tracing__c>   
       */    

    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds) {
        return [SELECT Id, Person__c, Location__c 
            FROM Location_Tracing__c
            WHERE Location__c IN :locationIds
            AND Person__r.Health_Status__c = 'Green'
            AND Visit_Date__c = LAST_N_DAYS:10];
    }

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces) {
        // Storen unique location ids
        Set<Id> locationIds = new Set<Id>();
        // Storen unique person ids
        Set<Id> personIds = new Set<Id>(); 
        for(Location_Tracing__c trace : newLocationTraces) {
            locationIds.add(trace.Location__c);
            personIds.add(trace.personIds);
        }

        // map of location id, set of person ids
        Map<Id, Set<Id>> mapOfExistingRecods = new  Map<Id, Set<Id>>();

        // query existing location tracing records
        List<Location_Tracing_c> existingRecords = [SELECT Id, Person__c, Location__c 
                                                        FROM Location_Tracing__c
                                                        WHERE Location__c IN :locationIds
                                                        AND Person__c IN :personIds];

        // list of duplicates records
        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();
        
        
        if(existingRecords != null && existingRecords.size() > 0) {
            for(Location_Tracing__c trace : existingRecords) {
                if(!mapOfExistingRecods.containsKey(trace.Location__c)) {
                    mapOfExistingRecods.put(trace.Location__c, new Set<Id>());
                }

                // add person ids to map set
                mapOfExistingRecods.get(trace.Location__c).add(trace.Person__c);
            }
            //loop over new locatiom tracing records

            for(Location_Tracing__c trace : newLocationTraces) {
                // first check for location id
                // if item found in map, then check for person id in set
                if()
            }
        }                                                    
    }
}