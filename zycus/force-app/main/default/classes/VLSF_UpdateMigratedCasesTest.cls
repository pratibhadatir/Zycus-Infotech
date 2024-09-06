@isTest
public class VLSF_UpdateMigratedCasesTest {
    @isTest
    static void setup() {
        
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
        
        // Insert test data for BMCServiceDesk__Incident__c
        List<BMCServiceDesk__Incident__c> incidents = new List<BMCServiceDesk__Incident__c>();
        for (Integer i = 0; i < 5; i++) {
            incidents.add(new BMCServiceDesk__Incident__c(
                    Subject__c = 'New Problem Check testing ' + i, 
                    Incident_origin__c = 'Email', 
                    Product__c = 'iPerform', 
                    QA_status__c = 'Open', 
                    Region__c = 'Global', 
                    BMCServiceDesk__IncidentType__c = 'Incident', 
                    Reported_By__c = 'External', 
                    BMCServiceDesk__incidentDescription__c = 'Description field value', 
                    BMCServiceDesk__FKStatus__c = sta.Id,
                    BMCServiceDesk__RF_SkipTriggerExecution__c=true,
                    Case_Type__c = 'Bug', 
                    BMCServiceDesk__Compliments_and_Complaints__c = 'ensure they are populated with', 
                    Workaround_provided__c = 'Yes', 
                    TeamT__c = 'Certinal', 
                    Team__c = 'Certinal',
                    Assigned_To__c='Team_Certinal',
                    Workaround_time__c = System.now(), 
                    BMCServiceDesk__FKAccount__c = testAccount.Id
            ));
        }
        insert incidents;
        
        // Insert test data for Case
        List<Case> cases = new List<Case>();
        for (BMCServiceDesk__Incident__c incident : incidents) {
            cases.add(new Case(
                VLSF_Link_Incident__c = incident.Id,
                Subject = 'Test Case for ' + incident.Name,
                Status = 'Opened'
        
            ));
        }
        insert cases;
        
      
        // Insert test data for BMCServiceDesk__IncidentHistory__c
        List<BMCServiceDesk__IncidentHistory__c> testIncidentHistory = new List<BMCServiceDesk__IncidentHistory__c>();
      for (BMCServiceDesk__Incident__c incident : incidents) { testIncidentHistory.add(new BMCServiceDesk__IncidentHistory__c(
                BMCServiceDesk__note__c = 'Test Note ' + incident.Name, 
                BMCServiceDesk__description__c = 'Test Description ' + incident.Name, 
                BMCServiceDesk__FKIncident__c = incident.Id, 
                BMCServiceDesk__FKAction__c = actions[1].Id
            ));
        }
     
        
        for (BMCServiceDesk__Incident__c incident : incidents) { testIncidentHistory.add(new BMCServiceDesk__IncidentHistory__c(
                BMCServiceDesk__note__c = 'Test Note ' + incident.Name, 
                BMCServiceDesk__description__c = 'Test Description ' + incident.Name, 
                BMCServiceDesk__FKIncident__c = incident.Id, 
                BMCServiceDesk__FKAction__c = actions[0].Id
            ));
        }
          insert testIncidentHistory;
        // Insert test data for VLSF_Case_Historical_Data__c
        List<VLSF_Case_Historical_Data__c> historicalDataList = new List<VLSF_Case_Historical_Data__c>();
        for (Case caseRec : cases) {
            historicalDataList.add(new VLSF_Case_Historical_Data__c(
                VLSF_Case__c = caseRec.Id,
                VLSF_Link_Incident__c=caseRec.VLSF_Link_Incident__c
            ));
        }
        insert historicalDataList;
        
        
         Test.startTest();
        Database.executeBatch(new VLSF_UpdateMigratedCases(), 200);
        Test.stopTest();
        
    }

}