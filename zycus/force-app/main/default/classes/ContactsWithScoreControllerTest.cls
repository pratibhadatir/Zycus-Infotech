@isTest
public class ContactsWithScoreControllerTest {
    @isTest
    static void testContactsWithScoreController() {
        // Create test data
        Contact testContact1 = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Salesforce_Score__c = 2
        );
        Contact testContact2 = new Contact(
            FirstName = 'Jane',
            LastName = 'Smith',
            Salesforce_Score__c = 0
        );

        // Insert the test data
        List<Contact> contactsToInsert = new List<Contact>{testContact1, testContact2};
        insert contactsToInsert;

        // Create an instance of the controller class
        ContactsWithScoreController controller = new ContactsWithScoreController();

        // Verify that the controller query correctly filters contacts with a score >= 1
        System.assertEquals(1, controller.contacts.size(), 'Expected only one contact with a score >= 1');

        // Verify the data of the contact in the list
        Contact retrievedContact = controller.contacts[0];
        System.assertEquals('John', retrievedContact.FirstName, 'First name does not match');
        System.assertEquals('Doe', retrievedContact.LastName, 'Last name does not match');
        System.assertEquals(2, retrievedContact.Salesforce_Score__c, 'Score does not match');
    }
}