public class ContactsWithScoreController {
    public List<Contact> contacts { get; set; }

    public ContactsWithScoreController() {
        // Query the contacts with a Total Contact Score greater than or equal to 1
        contacts = [SELECT Id, FirstName, Lastname,  Salesforce_Score__c, Total_Contact_Score__c FROM Contact WHERE Total_Contact_Score__c >= 1];
    }
}