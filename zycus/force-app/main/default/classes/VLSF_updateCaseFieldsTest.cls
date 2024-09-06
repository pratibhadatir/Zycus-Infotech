@isTest
public class VLSF_updateCaseFieldsTest {
 @isTest
    static void testBatchExecution(){
        // Create test data
        Account testAccount = new Account(
            Name = 'Test Account', 
            BillingCountry = 'India', 
            BillingState = 'Delhi'
        );
        insert testAccount;
        //BMCServiceDesk__Status__c sta = [Select Id from BMCServiceDesk__Status__c where Name ='In Progress'];
        BMCServiceDesk__Status__c sta = new BMCServiceDesk__Status__c();
        sta.Name = 'CLOSED';
        sta.BMCServiceDesk__appliesToIncident__c = true;
        sta.BMCServiceDesk__inactive__c = false;
        Insert sta;

        BMCServiceDesk__Status__c stat = new BMCServiceDesk__Status__c();
        stat.Name = 'In Progress';
        stat.BMCServiceDesk__appliesToIncident__c = true;
        stat.BMCServiceDesk__inactive__c = false;
        Insert stat;

        BMCServiceDesk__Status__c stats = new BMCServiceDesk__Status__c();
        stats.Name = 'Rejected';
        stats.BMCServiceDesk__appliesToIncident__c = true;
        stats.BMCServiceDesk__inactive__c = false;
        Insert stats;

        BMCServiceDesk__Status__c parked = new BMCServiceDesk__Status__c();
        parked.Name = 'Reopen';
        parked.BMCServiceDesk__appliesToIncident__c = true;
        parked.BMCServiceDesk__inactive__c = false;
        Insert parked;

        BMCServiceDesk__Status__c resolve = new BMCServiceDesk__Status__c();
        resolve.Name = 'Awaiting Deployment';
        resolve.BMCServiceDesk__appliesToIncident__c = true;
        resolve.BMCServiceDesk__inactive__c = false;
        Insert resolve;
        
        BMCServiceDesk__Status__c resol = new BMCServiceDesk__Status__c();
        resol.Name = 'Resolved: RM-Partner';
        resol.BMCServiceDesk__appliesToIncident__c = true;
        resol.BMCServiceDesk__inactive__c = false;
        Insert resol;
        
        BMCServiceDesk__Status__c resolv = new BMCServiceDesk__Status__c();
        resolv.Name = 'Resolved';
        resolv.BMCServiceDesk__appliesToIncident__c = true;
        resolv.BMCServiceDesk__inactive__c = false;
        Insert resolv;

        List<BMCServiceDesk__Action__c> actions = new List<BMCServiceDesk__Action__c>{ new BMCServiceDesk__Action__c(
            Name = 'Email Received'
        ), new BMCServiceDesk__Action__c(
            Name = 'Notes'
        ) };
        insert actions;

        List<BMCServiceDesk__Incident__c> testIncidents = new List<BMCServiceDesk__Incident__c>();
        // Create test incidents
        for (Integer i = 0; i < 7; i++){
            if (i == 0){
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'iPerform', 
                    RM_ID__c = 'w3ffecsa', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'Service Request', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__FKStatus__c = sta.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    BMCServiceDesk__incidentResolution__c = 'BMCServiceDesk__incidentResolution__c', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Team__c = 'SRE', 
                    Issue_escaped__c = 'Implementation', 
                    Assigned_To__c = 'Team_Certinal', 
                    Workaround_time__c = System.now(), 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            } 
            else if (i == 1){
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'Not availbenjvdjkjsdfjf', 
                    QA_status__c = 'Open', 
                    RM_ID__c = 'w3ffecsa', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'Event Management', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__incidentResolution__c = 'BMCServiceDesk__incidentResolution__c', 
                    BMCServiceDesk__FKStatus__c = stat.Id, 
                    Case_Type__c = 'Bug', 
                    Issue_escaped__c = 'Implementation', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Team__c = 'Certinal', 
                    Assigned_To__c = 'Team_Certinal', 
                    Workaround_time__c = System.now(), 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            } 
            else if (i == 2){
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'iPerform', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    RM_ID__c = 'w3ffecsa', 
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__incidentResolution__c = 'BMCServiceDesk__incidentResolution__c', 
                    BMCServiceDesk__FKStatus__c = stats.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Team__c = 'Certinal', 
                    Context__c='Integration',
                    Issue_escaped__c = 'Implementation', 
                    Assigned_To__c = 'Team_Certinal', 
                    Workaround_time__c = System.now(), 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            } 
            else if (i == 3){
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'iPerform', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'RCA for Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__incidentResolution__c = 'BMCServiceDesk__incidentResolution__c', 
                    BMCServiceDesk__FKStatus__c = resolve.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Issue_escaped__c = 'Implementation', 
                    Team__c = 'Certinal', 
                    Assigned_To__c = 'Team_Certinal', 
                    Workaround_time__c = System.now(), 
                    RM_ID__c = 'w3ffecsa', 
                    Context__c='Integration',
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            } 
            else if (i == 4){
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'iPerform', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    Context__c='Integration',
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__incidentResolution__c = 'BMCServiceDesk__incidentResolution__c', 
                    BMCServiceDesk__FKStatus__c = resol.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Issue_escaped__c = 'Implementation', 
                    Team__c = 'Certinal', 
                    Assigned_To__c = 'Team_Certinal', 
                    Workaround_time__c = System.now(), 
                    RM_ID__c = 'w3ffecsa', 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            } 
            else if (i == 5){
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'iPerform', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__incidentResolution__c = 'BMCServiceDesk__incidentResolution__c', 
                    BMCServiceDesk__FKStatus__c = resolv.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Issue_escaped__c = 'Implementation', 
                    Team__c = 'Certinal', 
                    Assigned_To__c = 'Team_Certinal', 
                    Workaround_time__c = System.now(),
                     Context__c='Integration',
                    RM_ID__c = 'w3ffecsa', 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            }  
            else if (i == 6){
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'iPerform', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__incidentResolution__c = 'BMCServiceDesk__incidentResolution__c', 
                    BMCServiceDesk__FKStatus__c = resolv.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Issue_escaped__c = 'Implementation', 
                    Team__c = 'Certinal', 
                    Assigned_To__c = 'Team_Certinal', 
                    Workaround_time__c = System.now(), 
                    RM_ID__c = 'w3ffecsa', 
                     Context__c='Integration',
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            }
            else{
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'Iphone', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    RM_ID__c = 'w3ffecsa', 
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__incidentResolution__c = 'BMCServiceDesk__incidentResolution__c', 
                    BMCServiceDesk__FKStatus__c = parked.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Not Applicable', 
                    TeamT__c = 'Monday', 
                    Issue_escaped__c = 'Implementation', 
                    Team__c = 'Sunday',
                     Context__c='Integration',
                    Assigned_To__c = 'Team_Certinal', 
                    Workaround_time__c = System.now(), 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
               testIncidents.add(testIncident);
            }
        }
        insert testIncidents;
         List<Case> insertcases =new List<Case>();
        for(Integer i=0;i<4;i++){
           Case linkedCase = new Case(
            VLSF_Link_Incident__c = testIncidents[0].Id,
              Status = 'Opened',
             Subject = 'Test Case'
        );
         insertcases.add(linkedCase);
        }
        insert insertcases;
        
         Test.startTest();
        Database.executeBatch(new VLSF_updateCaseFields(), 200);
        Test.stopTest();
    }
}