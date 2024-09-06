@isTest class test_CreateUpdateContact_Handler {
    @TestSetup
    static void makeData(){
        
    }   
    @isTest static void test1() {
        list<Contact> conList = new list<Contact>();
        
        Contact Con = new Contact();
        Con.FirstName = 'test';
        Con.LastName = 'Name1';
        Con.Email = 'test1@example.com';
        Con.Country__c = 'India';
        conList.add(Con);
        
        Contact Con2 = new Contact();
        Con2.FirstName = 'test';
        Con2.LastName = 'Name1';
        Con2.Email = 'test3@example.com';
        Con2.Country__c = 'India';
        conList.add(Con2);
        
        Contact Con3 = new Contact();
        Con3.FirstName = 'test';
        Con3.LastName = 'Name2';
        Con3.Email = 'test4@example.com';
        Con3.Country__c = 'India';
        conList.add(Con3);
        insert conList;
        
        list<Account> accList = new list<Account>();
        Account acc1 = new Account();
        acc1.Name = 'test company name 1';
        acc1.BillingCountry = 'India';
        //acc1.Type = 'Customer';
        //acc1.BillingState = 'Uttar Pradesh';
        //acc1.State_Division__c = 'North';
        accList.add(acc1);
        insert accList;
        
        List<Contact_Custom__c> cConList = new List<Contact_Custom__c>();
        Contact_Custom__c cCon = new Contact_Custom__c();
        cCon.Email__c = 'test1@example.com';
        ccon.FirstName__c = 'test';
        cCon.LastName__c = 'Name1';
        cCon.Company_Name__c = 'test company name 1';
        cCon.Country__c = 'India';
        cConList.add(cCon);

        Contact_Custom__c cCon2 = new Contact_Custom__c();
        cCon2.Email__c = 'test2@example.com';
        ccon2.FirstName__c = 'test';
        cCon2.LastName__c = 'Name1';
        cCon2.Company_Name__c = 'test company name 1';
        cCon2.Country__c = 'India';
        cConList.add(cCon2);
        
        Contact_Custom__c cCon3 = new Contact_Custom__c();
        cCon3.Email__c = 'test2@example.com';
        cCon3.FirstName__c = 'test';
        cCon3.LastName__c = 'Name3';
        cCon3.Company_Name__c = 'test company name 1';
        cCon3.Country__c = 'India';
        cConList.add(cCon3);
        
        Contact_Custom__c cCon4 = new Contact_Custom__c();
        cCon4.Email__c = 'test2@example.com';
        cCon4.FirstName__c = 'test';
        cCon4.LastName__c = 'Name3';
        cCon4.Company_Name__c = 'test c';
        cCon4.Country__c = 'India';
        cConList.add(cCon4);
        insert cConList;
    }
    
    static void test2() {
        list<Contact> conList = new list<Contact>();
        
        Contact Con = new Contact();
        Con.FirstName = 'test';
        Con.LastName = 'Name1';
        Con.Email = 'test1@example.com';
        Con.Country__c = 'India';
        conList.add(Con);
        
        Contact Con2 = new Contact();
        Con2.FirstName = 'test';
        Con2.LastName = 'Name1';
        Con2.Email = 'test3@example.com';
        Con2.Country__c = 'India';
        conList.add(Con2);
        
        Contact Con3 = new Contact();
        Con3.FirstName = 'test';
        Con3.LastName = 'Name2';
        Con3.Email = 'test4@example.com';
        Con3.Country__c = 'India';
        conList.add(Con3);
        insert conList;
        
        list<Account> accList = new list<Account>();
        Account acc1 = new Account();
        acc1.Name = 'test company name 1';
        acc1.BillingCountry = 'India';
        //acc1.Type = 'Customer';
        //acc1.BillingState = 'Uttar Pradesh';
        //acc1.State_Division__c = 'North';
        accList.add(acc1);
        insert accList;
        
        List<Contact_Custom__c> cConList = new List<Contact_Custom__c>();
        Contact_Custom__c cCon = new Contact_Custom__c();
        cCon.Email__c = 'test1@example.com';
        ccon.FirstName__c = 'test';
        cCon.LastName__c = 'Name1';
        cCon.Company_Name__c = 'test company name 1';
        cCon.Country__c = 'India';
        cConList.add(cCon);

        Contact_Custom__c cCon2 = new Contact_Custom__c();
        cCon2.Email__c = 'test2@example.com';
        ccon2.FirstName__c = 'test';
        cCon2.LastName__c = 'Name1';
        cCon2.Company_Name__c = 'test company name 1';
        cCon2.Country__c = 'India';
        cConList.add(cCon2);
        
        Contact_Custom__c cCon3 = new Contact_Custom__c();
        cCon3.Email__c = 'test2@example.com';
        cCon3.FirstName__c = 'test';
        cCon3.LastName__c = 'Name3';
        cCon3.Company_Name__c = 'test company name 1';
        cCon3.Country__c = 'India';
        cConList.add(cCon3);
        
        Contact_Custom__c cCon4 = new Contact_Custom__c();
        cCon4.Email__c = 'test2@example.com';
        cCon4.FirstName__c = 'test';
        cCon4.LastName__c = 'Name3';
        cCon4.Company_Name__c = 'test c';
        cCon4.Country__c = 'India';
        cConList.add(cCon4);
        insert cConList;
    }
    
    // to get the coverage of the RecordKey wrapper class.
    @isTest static void test3() {
        system.debug('test3s');
        wrapperRecordKey rk1 = new wrapperRecordKey(2, new list<string>{'test1', 'test2'}, new list<boolean>{true, true});
        wrapperRecordKey rk2 = new wrapperRecordKey(3, new list<string>{'test1', 'test2', 'test3'}, new list<boolean>{true, true, true});
		system.debug(rk1 == rk2);        
        wrapperRecordKey rk3 = new wrapperRecordKey(2, new list<string>{'test3', 'test2'}, new list<boolean>{true, true});
        system.debug(rk1 == rk3);
        wrapperRecordKey rk4 = new wrapperRecordKey(2, new list<string>{'test1', 'test2'}, new list<boolean>{true, false});
        wrapperRecordKey rk5 = new wrapperRecordKey(2, new list<string>{'test1', null}, new list<boolean>{true, false});
        system.debug(rk5 == rk4);
        object i = 0;
        system.debug(rk1 == i);
    }
}