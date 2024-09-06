@isTest(seeAllData=true)
public class TestDataFactory {
    public static  Id createOneIncident(){
        
        BMCServiceDesk__Incident__c inc = new BMCServiceDesk__Incident__c( 	
    															  BMCServiceDesk__FKClient__c = getIdForClient(),  	
																  BMCServiceDesk__incidentDescription__c='Test',
																  Subject__c = 'Test',
																  BMCServiceDesk__IncidentType__c = 'Incident',
																  Incident_origin__c = 'call',
																  Reported_By__c = 'External',
																  Product__c = 'iSave',
																  KEDB_Updated__c = 'No',
            													 
																  BMCServiceDesk__FKUrgency__c =getIdForUrgency(),
    															  BMCServiceDesk__FKImpact__c = getIdForImpact(), 	
																  BMCServiceDesk__FKCategory__c = getIdForCategory() ) ;
        insert inc ;
        System.debug('Incident created from factory   ' + inc.name);
        return inc.Id ;
    }
    
    
    
    
    
    
    
     public static  Id createOneProblem(){
        BMCServiceDesk__Problem__c pbm = new BMCServiceDesk__Problem__c( 	
    														
																  BMCServiceDesk__Problem_Description__c='Test',
																  Subject__c = 'Test',
																  KEDB_Updated__c = 'No',
																  BMCServiceDesk__FKUrgency__c =getIdForUrgency(),
    															  BMCServiceDesk__FKImpact__c = getIdForImpact() 	
																  ) ;
        insert pbm ;
        System.debug('Incident created from factory   ' + pbm.name);
        return pbm.Id ;
    }
    
     public static void createOneCategory(){
       BMCServiceDesk__Category__c cat = new BMCServiceDesk__Category__c(name = 'testCategory' ) ;
       insert cat ;
       
    }
    
    public static  BMCServiceDesk__Task__c createOneTask(){
        BMCServiceDesk__Task__c ta = new BMCServiceDesk__Task__c() ;
        insert ta ;
        
        return ta ;
    }
    
    public static Id  createOneRelease(){
        BMCServiceDesk__Release__c r = new BMCServiceDesk__Release__c(
        							   Subject__c = 'Test',
                                       Product__c = 'iSource',
            						   BMCServiceDesk__Release_Title__c = 'Test',	
            						   BMCServiceDesk__FKTemplate__c = getIdForTemplate(),
                                       BMCServiceDesk__FKUrgency__c =getIdForUrgency(),
                                       BMCServiceDesk__FKImpact__c = getIdForImpact(),
            						   Reported_By__c = 'External' 			
        ) ;
        insert r ;
        return r.Id ;
    }
    
    
    
	public static String getIdForTemplate(){
        //BMCServiceDesk__Impact__c imp = new BMCServiceDesk__Impact__c(name = 'testImpact' ) ;
        //insert imp;
        BMCServiceDesk__SYSTemplate__c res = [select id from BMCServiceDesk__SYSTemplate__c where name = 'Major Release - Task List'];
        String templId = res.id ;
        System.debug('ID FOR IMPACT  ' + templId);
        return templId ;
    }		        
        
    public static String getIdForImpact(){
        //BMCServiceDesk__Impact__c imp = new BMCServiceDesk__Impact__c(name = 'testImpact' ) ;
        //insert imp;
        BMCServiceDesk__Impact__c res = [select id from BMCServiceDesk__Impact__c where name = 'High'];
        String impactID = res.id ;
        System.debug('ID FOR IMPACT  ' + impactID);
        return impactID ;
    }
    
    public static String getIdForUrgency(){
        //BMCServiceDesk__Urgency__c ur = new BMCServiceDesk__Urgency__c(name = 'testUrgency' ) ;
        //insert ur ;
        BMCServiceDesk__Urgency__c res = [select id from BMCServiceDesk__Urgency__c where name = 'High'];
        String urgencyID = res.id;
        System.debug('ID FOR Urgency  ' + urgencyID);
        return res.Id ;
    }
    
    public static String getIdForCategory(){
        BMCServiceDesk__Category__c res = [select id from BMCServiceDesk__Category__c where name = 'testCategory'];
        String catID = res.id;
        System.debug('ID FOR catID  ' + catID);
	    return catID ;
    }
    
    public static String getIdForClient(){
       User res = [select id,name from User where name = 'Shraddha Patni'];
       String clientID = res.id;
       System.debug('ID FOR CLient  ' + clientID);
       return clientID ;
    }
}