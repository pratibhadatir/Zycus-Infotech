public class ActivityTimelineController {
    private final Account account;
    public List<Event> eventActivities { get; set; }
    public List<Task> taskActivities { get; set; }

    public ActivityTimelineController(ApexPages.StandardController stdController) {
        this.account = (Account)stdController.getRecord();
    }

    public void loadActivities() {
        List<Id> relatedIds = new List<Id>();
        relatedIds.add(account.Id);
        
        for (Opportunity opp : [
            SELECT Id
            FROM Opportunity
            WHERE AccountId = :account.Id
        ]) {
            relatedIds.add(opp.Id);
        }
        
        Set<Id> contactIds = new Set<Id>();
        for (Contact contact : [
            SELECT Id
            FROM Contact
            WHERE AccountId = :account.Id
        ]) {
            contactIds.add(contact.Id);
        }

        eventActivities = [
            SELECT Id, Sub_Category__c, StartDateTime, Who.Name, Who.Title, Gold_Email_Zycus__c, Subject, Assigned_Role__c
            FROM Event
            WHERE (WhatId IN :relatedIds OR WhoId IN :contactIds)
                AND StartDateTime >= LAST_N_DAYS:30
                AND Assigned_Role__c = 'Zycus'
                AND Sub_Category__c != 'Influ2'
            ORDER BY StartDateTime DESC
        ];
        taskActivities = [
            SELECT Id, Sub_Category__c, ActivityDate, Who.Name, Who.Title, Gold_Email_Zycus__c, Subject, Assigned_Role__c
            FROM Task
            WHERE (WhatId IN :relatedIds OR WhoId IN :contactIds)
                AND ActivityDate >= LAST_N_DAYS:30
                AND Assigned_Role__c = 'Zycus'
                AND Sub_Category__c != 'Influ2'
            ORDER BY ActivityDate DESC
        ];
    }
}