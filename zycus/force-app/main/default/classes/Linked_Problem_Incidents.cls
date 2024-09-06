public class Linked_Problem_Incidents {
    public static void getIncident(String pbmName){
        System.debug('getIncident() started');
        BMCServiceDesk__Incident_Problem_Link__c[] linkedInc = [Select Name,BMCServiceDesk__FKIncident__r.name from BMCServiceDesk__Incident_Problem_Link__c inc where inc.BMCServiceDesk__FKProblem__r.name = :pbmName] ;
        System.debug('' + linkedInc);
        For(BMCServiceDesk__Incident_Problem_Link__c inc : linkedInc ){
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
     
}