@isTest class test_AddContAsCampMem {
    @isTest static void test1() {
        Campaign cm = new Campaign();
        cm.name = 'test Campaign';
        cm.Commited_End_Date__c = system.today() + 1;
        cm.Type = 'Database';
        system.debug('cam1');
        insert cm;
        
        campaign cm2 = new Campaign();
        cm2.name = 'test campaign2';
        cm2.Commited_End_Date__c = system.today() + 1;
        cm2.Type = 'Webinar';
        system.debug('cam2');
        insert cm2;
        
        contact con = new contact();
        con.lastname = 'test contact';
        con.Secondary_Source__c = 'test Campaign';
        con.Opportunity_Source__c = 'Database';
        system.debug('con ins');
        
        insert con;
        
        con.Secondary_Source__c = 'test campaign2';
        con.Opportunity_Source__c = 'Webinar';
        system.debug('con upd');
        update con;
    }
}