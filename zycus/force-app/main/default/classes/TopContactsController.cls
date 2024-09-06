public class TopContactsController {
    private final Account account;
    public List<ContactActivityWrapper> topContacts { get; set; }

    public TopContactsController(ApexPages.StandardController stdController) {
        this.account = (Account)stdController.getRecord();
        loadTopContacts();
    }

    public void loadTopContacts() {
        topContacts = new List<ContactActivityWrapper>();

        // Aggregate query to count activities by WhoId where Assigned_Role__c is 'zycus'
        AggregateResult[] results = [
            SELECT WhoId, COUNT(Id) numActivities
            FROM Task
            WHERE WhatId = :account.Id
              AND ActivityDate >= LAST_N_DAYS:15
              AND Who.Type = 'Contact'
              AND Assigned_Role__c = 'zycus'
            GROUP BY WhoId
            ORDER BY COUNT(Id) DESC
        ];

        // Prepare a map to hold WhoId and activity counts
        Map<Id, Integer> contactActivityCounts = new Map<Id, Integer>();
        for (AggregateResult ar : results) {
            contactActivityCounts.put((Id)ar.get('WhoId'), (Integer)ar.get('numActivities'));
        }

        // Secondary query to get contact details if we have any contacts to look up
        if (!contactActivityCounts.isEmpty()) {
            List<Contact> contacts = [
                SELECT Id, Name, Title, Primary_Contact__c
                FROM Contact
                WHERE Id IN :contactActivityCounts.keySet()
            ];

            // Create wrapper list for displaying in Visualforce
            for (Contact contact : contacts) {
                Integer activityCount = contactActivityCounts.get(contact.Id);
                topContacts.add(new ContactActivityWrapper(
                    contact.Id,
                    contact.Name,
                    contact.Title,
                    contact.Primary_Contact__c,
                    activityCount
                ));
            }
        }
    }

    // Wrapper class to handle the display logic in Visualforce
    public class ContactActivityWrapper {
        public Id contactId { get; set; }
        public String name { get; set; }
        public String title { get; set; }
        public String isPrimary { get; set; } // Adjusted to String as indicated by error
        public Integer activityCount { get; set; }

        // Constructor to initialize the wrapper
        public ContactActivityWrapper(Id contactId, String name, String title, String isPrimary, Integer activityCount) {
            this.contactId = contactId;
            this.name = name;
            this.title = title;
            this.isPrimary = isPrimary;
            this.activityCount = activityCount;
        }
    }
}