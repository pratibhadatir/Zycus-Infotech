@isTest(seeAllData=false)
public class Batch_ContactProcessingTest {
static testMethod void testMethod1() 
    {
       List<Contact> lstCOntact= new List<Contact>();
        for(Integer i=0; i<10; i++)
        {
            Contact con = new Contact();
            con.FirstName = 'FName'+i;
            con.LastName = 'LName'+i;
            lstCOntact.add(con);
        }
        
        insert lstCOntact;
        
        Contact_Custom__c cc = new Contact_Custom__c();
        cc.Company_Name__c='company1';
        //cc.NameCountry_Key__c ='TEST';
        cc.Email__c='rshyam@mail.com';
        cc.Personal_email__c ='test2@mail2.com';
        cc.Secondary_Source__c='web';
        cc.FirstName__c='Amit';
        cc.LastName__c ='Sumit';
        insert cc;
        
        Test.startTest();

            Batch_ContactProcessing obj = new Batch_ContactProcessing();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}