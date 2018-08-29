public class kioskTriggerHandler{

    public static boolean firstRun = true;

    public void OnBeforeInsert(Kiosk__c[] newObjects){
    }

    public void OnAfterInsert(Kiosk__c[] newObjects){
        if(firstRun == true){
            set<id> ids = new set<id>();
            for(Kiosk__c k : newObjects){
                ids.add(k.id);
            }
            if(ids.size() > 0){
                LatLongLookup.Lat_Lon_Lookup(ids); 
            }
            firstRun = false; 
        }            
    }

    public void OnBeforeUpdate(Kiosk__c[] oldObjects, Kiosk__c[] updatedObjects, map<id,Kiosk__c> MapNewKioskMap, map<id,Kiosk__c> MapOldKioskMap){
    }

    public void OnAfterUpdate(Kiosk__c[] oldObjects, Kiosk__c[] updatedObjects, map<id,Kiosk__c> MapNewKioskMap, map<id,Kiosk__c> MapOldKioskMap){
        if(firstRun == true){
            set<id> ids = new set<id>();
            for(Kiosk__c k : updatedObjects){
                if((MapOldKioskMap.get(k.id).Zip_Code__c != k.Zip_Code__c || k.Latitude__c == null) && (k.Lat_Lon_Looked_Up_At__c < datetime.now().addminutes(-2) || k.Lat_Lon_Looked_Up_At__c == null)){
                    ids.add(k.id); 
                }                
            } 
            if(ids.size() > 0){
                LatLongLookup.Lat_Lon_Lookup(ids); 
            }
            firstRun = false;
        }
    }

    public void OnBeforeDelete(Kiosk__c[] ObjectsToDelete, map<id,Kiosk__c> MapNewKioskMap, map<id,Kiosk__c> MapOldKioskMap){
    }

    public void OnAfterDelete(Kiosk__c[] deletedObjects, map<id,Kiosk__c> MapNewKioskMap, map<id,Kiosk__c> MapOldKioskMap){
    }

    public void OnUndelete(Kiosk__c[] restoredObjects){
    }

}