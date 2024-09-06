public class Linked_Release_Incidents {
	    public static void getIncident(String releaseName){
            System.debug('getIncident() started');
            BMCServiceDesk__Release_Incident_Link__c[] linkedInc = [select id,name,BMCServiceDesk__FKIncident__r.name,BMCServiceDesk__FKRelease__r.name from BMCServiceDesk__Release_Incident_Link__c where BMCServiceDesk__FKRelease__r.name =:releaseName] ;
            System.debug('' + linkedInc);
            For(BMCServiceDesk__Release_Incident_Link__c inc : linkedInc ){
                System.debug('Retrieved Incident Number :  ' + inc.BMCServiceDesk__FKIncident__r.name);
                resolveIncident(inc.BMCServiceDesk__FKIncident__r.name);
            }
            
            System.debug('getIncident() ends ');
    	}
    
        public static void resolveIncident(String incName){
            System.debug('resolveIncident() starts ');
            BMCServiceDesk__Incident__c inc = [Select Name,BMCServiceDesk__FKStatus__c from BMCServiceDesk__Incident__c inc where inc.name = :incName] ;
            inc.BMCServiceDesk__FKStatus__c = StatusUpdate.getIdForStatus('RESOLVED');
            
              
             try{
                  TriggerFlag.setUpdateFlag(); //To prevent the update trigger recursion.   
                  update inc ;   
             }
             Catch(Exception e){
                 System.debug('Getting error' + e.getMessage());     
             }
            System.debug('resolveIncident() starts ');
	    }

    	public static Boolean isLinkedToRelease(String incName){
            System.debug('setIsLinkedToRelease() starts');
            
            System.debug('Incident name' + incName);
            
            //BMCServiceDesk__Incident__c inc = [select name from BMCServiceDesk__Incident__c where id = :incID LIMIT 1];                
            BMCServiceDesk__Release_Incident_Link__c[] releaseInc = [select id,name,BMCServiceDesk__FKIncident__r.name,BMCServiceDesk__FKRelease__r.name from BMCServiceDesk__Release_Incident_Link__c lnkInc where lnkInc.BMCServiceDesk__FKIncident__r.name = : incName LIMIT 1]; 
            if(releaseInc.size()>0){
                            
                System.debug('linked to release');
                String releaseName = releaseInc[0].BMCServiceDesk__FKRelease__r.name;
                System.debug('Rerieved release name ' + releaseName);
                BMCServiceDesk__Release__c release= [select name,BMCServiceDesk__FKStatus__c from BMCServiceDesk__Release__c rel where rel.name = :releaseName LIMIT 1];                            	    
                if(release.BMCServiceDesk__FKStatus__c == StatusUpdate.getIdForStatus('CLOSED')){
                    System.debug('The release is closed');
                }
                else{
                    System.debug('The release is not closed');
                    return true;
                }
            }        
            else{
              	 System.debug('Not linked to release');
                 return false;
            }
           
            System.debug('setIsLinkedToRelease() ends ');     
            
            return true ;
   		 }
    
}