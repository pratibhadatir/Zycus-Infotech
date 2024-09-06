@isTest
public class VLSF_MigrationTask_2Test {
    
    @isTest
    static void setupData() {
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
        
        List<BMCServiceDesk__Action__c> actions = new List<BMCServiceDesk__Action__c>{ new BMCServiceDesk__Action__c(
            Name = 'Email Received'
        ), new BMCServiceDesk__Action__c(
            Name = 'Notes'
        ) };
        insert actions;

        // Create test incidents
        List<BMCServiceDesk__Incident__c> testIncidents = new List<BMCServiceDesk__Incident__c>();
        for (Integer i = 0; i < 3; i++){
            if(i==0){
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'iPerform', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__FKStatus__c = sta.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Team__c = 'Certinal',
                    Assigned_To__c='Team_Certinal',
                    Workaround_time__c = System.now(), 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            } else if(i==1){
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'iPerform', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__FKStatus__c = stats.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Team__c = 'Certinal',
                    Assigned_To__c='Team_Certinal',
                    Workaround_time__c = System.now(), 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            }else{
                BMCServiceDesk__Incident__c testIncident = new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'iPerform', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__FKStatus__c = stat.Id, 
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Team__c = 'Certinal',
                    Assigned_To__c='Team_Certinal',
                    Workaround_time__c = System.now(), 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
                );
                testIncidents.add(testIncident);
            }
        }
        insert testIncidents;
        List<Case> caseList = new List<Case>();
        for (Integer i = 0; i < 5; i++) {
            Case caseObj = new Case(
                Subject = 'Test Case ' + i,
                Status = 'Opened',
                VLSF_Link_Incident__c = testIncidents[0].Id
            );
            caseList.add(caseObj);
        }
        insert caseList;

        // Create sample BMCServiceDesk__IncidentHistory__c records
        List<BMCServiceDesk__IncidentHistory__c> testIncidentHistory = new List<BMCServiceDesk__IncidentHistory__c>();
        for (Integer i = 0; i < 3; i++){
            BMCServiceDesk__IncidentHistory__c testHistory = new BMCServiceDesk__IncidentHistory__c(
                BMCServiceDesk__note__c = 'Test Note ' + i, 
                BMCServiceDesk__description__c = 'Test Description ' + i, 
                BMCServiceDesk__FKIncident__c = testIncidents[i].Id, 
                BMCServiceDesk__FKAction__c = actions[1].Id
            );
            testIncidentHistory.add(testHistory);
        }
        insert testIncidentHistory;
        
        List<BMCServiceDesk__IncidentHistory__c> testIncidentHistory2 = new List<BMCServiceDesk__IncidentHistory__c>();
        for (Integer i = 0; i < 3; i++){
            BMCServiceDesk__IncidentHistory__c testHistory1= new BMCServiceDesk__IncidentHistory__c(
                BMCServiceDesk__note__c = 'Test Note ' + i, 
                BMCServiceDesk__description__c = 'Test Description ' + i, 
                BMCServiceDesk__FKIncident__c = testIncidents[i].Id, 
                BMCServiceDesk__FKAction__c = actions[0].Id
            );
            testIncidentHistory2.add(testHistory1);
        }
        insert testIncidentHistory2;

        List<BMCServiceDesk__Task__c> testTasks = new List<BMCServiceDesk__Task__c>();
        for (Integer i = 0; i < 3; i++){
            BMCServiceDesk__Task__c testTask = new BMCServiceDesk__Task__c(
                BMCServiceDesk__FKIncident__c = testIncidents[i].Id, 
                Subject__c = 'Test Subject ' + i, 
                BMCServiceDesk__FKStatus__c = sta.Id, 
                BMCServiceDesk__taskDescription__c = 'Test Description ' + i, 
                BMCServiceDesk__taskResolution__c = 'Test Resolution ' + i
            );
            testTasks.add(testTask);
        }
       insert testTasks;
        
         Test.startTest();
        Database.executeBatch(new VLSF_MigrationTask_2(), 200);
        Test.stopTest();
    }

}