@isTest
public class VLSF_UpdateMigratedCasesNewTest {
    @isTest
    static void setup() {
        
        Account testAccount = new Account(
            Name = 'Test Account', 
            BillingCountry = 'India', 
            BillingState = 'Delhi'
        );
        insert testAccount;
		//BMCServiceDesk__Status__c sta = [Select Id from BMCServiceDesk__Status__c where Name ='In Progress'];
        
        BMCServiceDesk__Status__c parked2 = new BMCServiceDesk__Status__c();
        parked2.Name = 'Parked';
        parked2.BMCServiceDesk__appliesToIncident__c = true;
        parked2.BMCServiceDesk__inactive__c = false;
        Insert parked2;
        
        BMCServiceDesk__Status__c sta = new BMCServiceDesk__Status__c();
        sta.Name = 'CLOSED';
        sta.BMCServiceDesk__appliesToIncident__c = true;
        sta.BMCServiceDesk__inactive__c = false;
        Insert sta;
                
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
        
        BMCServiceDesk__Status__c dulpicate = new BMCServiceDesk__Status__c();
        dulpicate.Name = 'Resolved Duplicate';
        dulpicate.BMCServiceDesk__appliesToIncident__c = true;
        dulpicate.BMCServiceDesk__inactive__c = false;
        Insert dulpicate;
        
        BMCServiceDesk__Status__c resol = new BMCServiceDesk__Status__c();
        resol.Name = 'Resolved: RM-Partner';
        resol.BMCServiceDesk__appliesToIncident__c = true;
        resol.BMCServiceDesk__inactive__c = false;
        Insert resol;
        
        BMCServiceDesk__Status__c stat = new BMCServiceDesk__Status__c();
        stat.Name = 'In Progress';
        stat.BMCServiceDesk__appliesToIncident__c = true;
        stat.BMCServiceDesk__inactive__c = false;
        Insert stat;
        
        BMCServiceDesk__Status__c resolve = new BMCServiceDesk__Status__c();
        resolve.Name = 'Awaiting Deployment';
        resolve.BMCServiceDesk__appliesToIncident__c = true;
        resolve.BMCServiceDesk__inactive__c = false;
        Insert resolve;
        
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
        for (Integer i = 0; i < 13; i++){
            if (i == 0){
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'iPerform', 
                    RM_ID__c = 'w3ffecsa', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__FKStatus__c = sta.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    BMCServiceDesk__incidentResolution__c = 'BMCServiceDesk__incidentResolution__c', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Ticket_Flow__c = 5,
                    Unassigned_L1__c = System.now(),
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
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__incidentResolution__c = 'BMCServiceDesk__incidentResolution__c', 
                    BMCServiceDesk__FKStatus__c = resolve.Id, 
                    Case_Type__c = 'Bug', 
                    Ticket_Flow__c = 5,
                    Unassigned_L1__c = System.now(),
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
            else if (i == 11){
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'Not availbenjvdjkjsdfjf', 
                    QA_status__c = 'Open', 
                    RM_ID__c = 'w3ffecsa', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__incidentResolution__c = 'BMCServiceDesk__incidentResolution__c', 
                    BMCServiceDesk__FKStatus__c = dulpicate.Id, 
                    Case_Type__c = 'Bug', 
                    Ticket_Flow__c = 5,
                    Unassigned_L1__c = System.now(),
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
                    Ticket_Flow__c = 5,
                    Unassigned_L1__c = System.now(),
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Team__c = 'Certinal', 
                    Issue_escaped__c = 'Implementation', 
                    Assigned_To__c = 'Team_Certinal', 
                    Workaround_time__c = System.now(), 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            } 
            else if (i == 12){
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'Not availbenjvdjkjsdfjf', 
                    QA_status__c = 'Open', 
                    RM_ID__c = 'w3ffecsa', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__incidentResolution__c = 'BMCServiceDesk__incidentResolution__c', 
                    BMCServiceDesk__FKStatus__c = stat.Id, 
                    Case_Type__c = 'Bug', 
                    Ticket_Flow__c = 5,
                    Unassigned_L1__c = System.now(),
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
            else if (i == 3){
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
                    BMCServiceDesk__FKStatus__c = resolve.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Issue_escaped__c = 'Implementation', 
                    Ticket_Flow__c = 5,
                    Unassigned_L1__c = System.now(),
                    Team__c = 'Certinal', 
                    Assigned_To__c = 'Team_Certinal', 
                    Workaround_time__c = System.now(), 
                    RM_ID__c = 'w3ffecsa', 
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
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__incidentResolution__c = 'BMCServiceDesk__incidentResolution__c', 
                    BMCServiceDesk__FKStatus__c = resol.Id, 
                    Case_Type__c = 'Bug', 
                    Ticket_Flow__c = 5,
                    Unassigned_L1__c = System.now(),
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
                    Ticket_Flow__c = 5,
                    Unassigned_L1__c = System.now(),
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
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            }
            else if (i == 7){
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
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            }
            else if (i == 9){
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
                    Ticket_Flow__c = 5,
                    Unassigned_L1__c = System.now(),
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
                    TeamT__c = 'Certinal', 
                    Issue_escaped__c = 'Implementation', 
                    Team__c = 'Certinal', 
                    Assigned_To__c = 'Team_Certinal', 
                    Workaround_time__c = System.now(), 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            }
        }
        insert testIncidents;
        
        // Insert test data for Case
        List<Case> cases = new List<Case>();
        for (BMCServiceDesk__Incident__c incident : testIncidents) {
            cases.add(new Case(
                VLSF_Link_Incident__c = incident.Id,
                Subject = 'Test Case for ' + incident.Name,
                Status = 'Opened',
                Origin = 'Email',
        		VLSF_Region__c = 'US', 
                VLSF_Product__c = 'iAnalyze',
                VLSF_Picklist_Severity__c = 'Low',
                VLSF_Impact__c = 'Low',
                VLSF_Track_Collateral_Damage__c = 'Yes',
                VLSF_Incident_Type__c = 'Incident',
                VLSF_Workaround_description__c = 'workareound provided',
                VLSF_Resolution__c = 'new resolution availabel ',
                VLSF_Root_Cause_analysis__c = 'root cauese analysis',
                AccountId = testAccount.Id,
                VLSF_Resolution_Code__c = 'Resolved Duplicate',
                Reason_KA_not_attached__c = 'The knowledge article may not directly address the issue or question raised in the case. Attaching irrelevant articles can confuse users and waste their time.',
                VLSF_Assigned_To__c = 'Team_Certinal'
            ));
        }
       insert cases;
        
        // Insert test data for VLSF_Case_Historical_Data__c
        List<VLSF_Case_Historical_Data__c> historicalDataList = new List<VLSF_Case_Historical_Data__c>();
        for (Case caseRec : cases) {
            historicalDataList.add(new VLSF_Case_Historical_Data__c(
                VLSF_Case__c = caseRec.Id,
                VLSF_Link_Incident__c=caseRec.VLSF_Link_Incident__c
            ));
        }
        insert historicalDataList;
        for (BMCServiceDesk__Incident__c incident : testIncidents) {
            incident.BMCServiceDesk__incidentDescription__c  = 'New Problem Check testing update';
        }
        update testIncidents;
        Test.startTest();
        Database.executeBatch(new VLSF_UpdateMigratedCasesNew(), 200);
        Test.stopTest();
        
    }

}