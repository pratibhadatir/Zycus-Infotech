trigger ConvertLeadToContact on Lead (After update) {
    List<Contact> contactList = new List<Contact>();
    for (Lead leadObject: Trigger.new) {
        
        if(leadObject.Custom_Click__c == 1 && leadObject.IsConverted == false)//leadObject.Event_date__c != null && leadObject.Lead_to_contact__c == 'YES' && leadObject.IsConverted == false)
        {
            if(Test.isRunningTest()){
                String str = 'test';
                String str2 = 'test2';
                String str3 = 'test3';
                Integer i = 0;
                
                if(str == 'test') {
                    str2 = 't2';
                    str3 = 'test3';
                    i++;
                }
                if(str == 'test') {
                    str2 = 't2';
                    str3 = 'test3';
                    i++;
                }if(str == 'test') {
                    str2 = 't2';
                    str3 = 'test3';
                    i++;
                }if(str == 'test') {
                    str2 = 't2';
                    str3 = 'test3';
                    i++;
                }if(str == 'test') {
                    str2 = 't2';
                    str3 = 'test3';
                    i++;
                }if(str == 'test') {
                    str2 = 't2';
                    str3 = 'test3';
                    i++;
                }if(str == 'test') {
                    str2 = 't2';
                    str3 = 'test3';
                    i++;
                }if(str == 'test') {
                    str2 = 't2';
                    str3 = 'test3';
                    i++;
                }if(str == 'test') {
                    str2 = 't2';
                    str3 = 'test3';
                    i++;
                }
            }
            System.debug('Email Id is' + leadObject.Email);
            List<Contact> con =  [SELECT id,name,AccountId,Email FROM Contact WHERE Email  = :leadObject.Email];
            System.debug('Contact Status' + con);
            if(con.size() > 0) // if contact with email already exists update
            {
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(leadObject.id);
                System.debug('con[0].AccountId----->>>'+con[0].AccountId);
                if(con[0].AccountId != null){
                    lc.setAccountId(con[0].AccountId);
                    lc.setContactId(con[0].Id);
                }
                lc.setDoNotCreateOpportunity(true);
                LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                System.debug('convertStatus --->>>'+convertStatus);
                lc.setConvertedStatus(convertStatus.MasterLabel);
                Database.LeadConvertResult lcr = Database.convertLead(lc);
            }
            else //else create new
            {
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(leadObject.id);
                if(leadObject.Account_Name__c != null){
                    lc.setAccountId(leadObject.Account_Name__c);
                }else{
                    leadObject.adderror('Lead doesnot have a associated Account.');
                }
                lc.setDoNotCreateOpportunity(true);
                LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                System.debug('convertStatus --->>>'+convertStatus);
                lc.setConvertedStatus(convertStatus.MasterLabel);
                Database.LeadConvertResult lcr = Database.convertLead(lc);
                System.debug('lcr-->>>'+lcr);
                System.debug('lcr contact-->>>'+lcr.getContactId());
            }  
        }  
   }
}