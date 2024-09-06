@isTest(SeeAllData=true)
private class Test_Linked_Rel_Incident {
    public static testmethod void testing_Trigger_Incident(){
        TestDataFactory.createOneCategory();
        
        String var_id = TestDataFactory.createOneIncident();
        BMCServiceDesk__Incident__c inc = [select name from BMCServiceDesk__Incident__c where id = :var_id];
            
        String realease_id = TestDataFactory.createOneRelease();
        BMCServiceDesk__Release__c r = [select name from BMCServiceDesk__Release__c where id = :realease_id];
        System.debug('Generated test Incident ' + inc.name );
        
        /*Testing for Linked_Release Incident */
        
        BMCServiceDesk__Release_Incident_Link__c Release_Incident_Link =  new BMCServiceDesk__Release_Incident_Link__c(
        BMCServiceDesk__FKIncident__c = var_id,
        BMCServiceDesk__FKRelease__c = realease_id    
        
        );

        insert Release_Incident_Link;
           
        
        
        Test.startTest();
	      Linked_Release_Incidents.isLinkedToRelease(inc.name);
          Linked_Release_Incidents.getIncident(r.name);	
              TriggerFlag.setUpdateFlag();
         	  Boolean flag = TriggerFlag.getUpdateFlag();
        //  MyProfilePageController.check();
          Test.stopTest();
    }

}