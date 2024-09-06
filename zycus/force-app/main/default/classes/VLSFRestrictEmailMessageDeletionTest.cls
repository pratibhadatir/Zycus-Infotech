@isTest
public class VLSFRestrictEmailMessageDeletionTest {
    
    @isTest
    static void testDeleteEmailMessage(){
       case caseid= new case (subject='Test case');
        insert caseid;
        
        EmailMessage testEmail = new EmailMessage(
            ParentId = caseid.Id,
            Subject = 'Test Email',
            TextBody = 'Test Body'
        );
        insert testEmail;
        Test.startTest();
        try {
            delete testEmail;
            System.assert(false, 'Expected DmlException was not thrown.');
        } catch (DmlException e) {
            
            System.assert(e.getMessage().contains('Unable to delete email message'), 'Unexpected error message: ' + e.getMessage());
        }
        Test.stopTest();
        
        
        testEmail = [SELECT Id FROM EmailMessage WHERE Id = :testEmail.Id ALL ROWS];
        System.assertNotEquals(null, testEmail, 'EmailMessage record should not have been deleted.');
    }
}