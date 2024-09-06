@isTest(SeeAllData=true)
private class Test_Linked_Pbm_Inc {
    public static testmethod void testing_Trigger_Incident(){
        TestDataFactory.createOneCategory();
        
        String var_id = TestDataFactory.createOneIncident();
        BMCServiceDesk__Incident__c inc = [select name from BMCServiceDesk__Incident__c where id = :var_id];
     
        
       
        String pbm_id = TestDataFactory.createOneProblem();
        BMCServiceDesk__Problem__c pbm = [select name from BMCServiceDesk__Problem__c where id = :pbm_id];
        
       
        /*Testing for Linked_Release Incident */
        
         BMCServiceDesk__Incident_Problem_Link__c Problem_Incident_Link =  new BMCServiceDesk__Incident_Problem_Link__c(
         BMCServiceDesk__FKIncident__c = var_id,
         BMCServiceDesk__FKProblem__c = pbm_id    
        
        );
        
        insert Problem_Incident_Link;
        
        
        Test.startTest();
        
          Linked_Problem_Incidents.getIncident(pbm.name);	
          
        //  MyProfilePageController.check();
          Test.stopTest();
    }

}