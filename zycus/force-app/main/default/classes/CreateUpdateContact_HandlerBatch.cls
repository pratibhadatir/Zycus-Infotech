global class CreateUpdateContact_HandlerBatch implements Database.Batchable<sObject>,Database.Stateful {
    
    List<Contact_Custom__c> lstConCustom = new List<Contact_Custom__c>();
    Set<Id> setOfIds = new Set<Id>();
    
    global CreateUpdateContact_HandlerBatch(List<Contact_Custom__c> conList){
        lstConCustom.addAll(conList);
        for(Contact_Custom__c eachCustomContact : conList){
            setOfIds.add(eachCustomContact.id);
        }
    }
    
    global Iterable<SObject> start(Database.BatchableContext BC) {
        // String query = 'Select Id, Campaign_ID__c, Campaign_Name__c, Company_Name__c, Name, Content_URL__c, Country__c, Date_of_Incoming_Lead__c, Event_Date__c, FirstName__c, LastName__c, LinkedIn_profile_URL__c, NameCountry_Key__c	, Opportunity_Source__c, Personal_email__c, Request_a_Demo__c, Secondary_Source__c, Title__c, Email__c FROM Contact_Custom__c LIMIT 9999';
        // system.debug('Start Query--> '+query);
        return lstConCustom;
    }
    
    global void execute(Database.BatchableContext BC, List<Contact_Custom__c> scope) {
        
        //Calling Wrapper Class
        List<wrapperRecordKey> accWrapper = new List<wrapperRecordKey>();
        
        //Declaring Lead Failure Logs
        List<Leads_Failure__c> lstLeadFailure = new List<Leads_Failure__c>();
        
        //Matching keys
        Set<String> emailKeys = new set<String>();
        Set<String> nameCountryKeys = new set<String>();
        
        //Map Keyset and values custom contact
        Map<String, Contact_Custom__c> emailConMap = new Map<String, Contact_Custom__c>();
        Map<String, Contact_Custom__c> nameConMap = new Map<String, Contact_Custom__c>();
        Map<String, Contact_Custom__c> companyConMap = new Map<String, Contact_Custom__c>();
        
        Set<String> countryNames = new Set<String>();
        Map<wrapperRecordKey, Account> fuzzyMatchMap = new Map<wrapperRecordKey, Account>();
        //Map Keyset and values standard contact
        Map<String, Contact> emailStConMap = new Map<String, Contact>();
        Map<String, Contact> nameCountryStConMap = new Map<String, Contact>();
        Map<String, Account> companyStAccMap = new Map<String, Account>();
        
        if(scope != null && scope.size() > 0){
            for(Contact_Custom__c con : scope) {
                system.debug(con.Email__c);
                system.debug(con.FirstName__c);
                System.debug(con.Company_Name__c);
                if(con.Email__c != null && con.Email__c != '') {
                    if(!emailConMap.containsKey(con.Email__c)) {
                        emailConMap.put(con.Email__c, con);
                    }
                }
                system.debug('emailConMap ====> ' + emailConMap);
                if(con.FirstName__c != null && con.FirstName__c != '' && 
                   con.LastName__c != null && con.LastName__c != '' &&
                   con.Country__c != null && con.Country__c != '') {
                       if(!nameConMap.containsKey(con.FirstName__c + con.LastName__c + con.Country__c)) {
                           nameConMap.put(con.FirstName__c + con.LastName__c + con.Country__c, con);
                       }
                   }
                system.debug('nameConMap ====> ' + nameConMap);
                
                if(con.Company_Name__c != null && con.Company_Name__c != '' &&
                   con.Country__c != null && con.Country__c != '') {
                       countryNames.add(con.Country__c);
                       if(!companyConMap.containsKey(con.Company_Name__c + con.Country__c)) {
                           companyConMap.put(con.Company_Name__c + con.Country__c, con);
                       }
                   }
                system.debug('companyConMap ====> ' + companyConMap);
            }
            
            if(!emailConMap.isEmpty()) {
                List<Contact> contactListemail = new List<Contact>([
                    Select id, lastname, firstname, email, accountId, Country__c, Secondary_Source__c, Opportunity_Source__c, Title, Campaign_ID__c, Campaign_Name__c, Personal_email__c, LinkedIn_Profile__c
                    from contact where email IN : emailConMap.keySet()
                ]);
                system.debug('contactListemail ====> ' + contactListemail);
                //If contacts exists on the basis of emails
                if(contactListemail != null && contactListemail.size() > 0) {
                    for(Contact con : contactListemail) {
                        if(!emailStConMap.containsKey(con.email)) {
                            emailStConMap.put(con.email, con);
                        }
                    }
                } 
                system.debug('emailStConMap =====> ' + emailStConMap);
            }
            
            if(!nameConMap.isEmpty()) {
                List<Contact> contactListNameCountry = new List<Contact>([
                    Select id, lastname, firstname, email, accountId, Country__c, Secondary_Source__c, Opportunity_Source__c, NameCountry_Key__c, Title, Campaign_ID__c, Campaign_Name__c, 
                    Personal_email__c, LinkedIn_Profile__c from contact where NameCountry_Key__c IN : nameConMap.keySet() and email NOT IN : emailStConMap.keyset()
                ]);
                system.debug('contactListNameCountry ====> ' + contactListNameCountry);
                //If contacts exists on the basis of Name and country
                if(contactListNameCountry != null && contactListNameCountry.size() > 0) {
                    for(Contact con : contactListNameCountry) {
                        if(!nameCountryStConMap.containsKey(con.NameCountry_Key__c)) {
                            nameCountryStConMap.put(con.NameCountry_Key__c, con);
                        }
                    }
                }
                system.debug('nameCountryStConMap ====> ' + nameCountryStConMap);
            }
            
            if(!companyConMap.isEmpty()) {
                List<Account> accList = new List<Account>([
                    Select id, Name, BillingCountry, NameCountry_Key__c from Account where BillingCountry in :countryNames
                ]);
                system.debug('accList ===> ' + accList);
                if(accList != null && accList.size() > 0) {
                    for(Account acc : accList) {
                        if(!companyStAccMap.containsKey(acc.NameCountry_Key__c)) {
                            companyStAccMap.put(acc.NameCountry_Key__c, acc);
                        }
                        system.debug('companyStAccMap ====> ' + companyStAccMap);
                        wrapperRecordKey nameCountry = new wrapperRecordKey(2, new list<string>{acc.Name, acc.BillingCountry}, new list<boolean>{false, true});
                        if(!fuzzyMatchMap.containsKey(nameCountry)) {
                            fuzzyMatchMap.put(nameCountry, acc);
                        }
                        system.debug('fuzzyMatchMap ====> ' + fuzzyMatchMap);
                    }
                }
            }
            
            List<Contact> upConList = new List<Contact>();
            Map<Id, Contact> upConMap = new Map<Id, Contact>();
            List<Contact> insConList = new List<Contact>();
            List<Account> insAccList = new List<Account>();
            
            //Check all cons
            for(Contact_Custom__c con : scope) {
                wrapperRecordKey conCompCountryKey = new wrapperRecordKey(2, new list<string>{con.Company_Name__c, con.Country__c}, new list<boolean>{false, true});
                if(fuzzyMatchMap.containsKey(conCompCountryKey)) {
                    system.debug('fuzzyMatchMap result ====> ' + fuzzyMatchMap.get(conCompCountryKey).Id);
                }
                system.debug('conCompCountryKey ===> ' + conCompCountryKey);
                //update contacts basis of Emails
                if(con.Email__c != null && con.Email__c != '') {
                    if(emailStConMap.containsKey(con.Email__c)) {
                        if(!upConMap.containsKey(emailStConMap.get(con.Email__c).id)) {
                            Contact stCon = new Contact();
                            stCon.id = emailStConMap.get(con.Email__c).id;
                            stCon.firstname = con.FirstName__c;
                            stCon.lastname = con.LastName__c;
                            stCon.Secondary_Source__c = con.Secondary_Source__c;
                            stCon.Opportunity_Source__c = con.Opportunity_Source__c;
                            //stCon.Title = con.Title__c;
                            stCon.Campaign_ID__c = con.Campaign_ID__c;
                            stCon.Opportunity_Source__c = con.Opportunity_Source__c;
                            stCon.Date_of_Incoming_Lead__c = con.Date_of_Incoming_Lead__c;
                            stCon.Event_Date__c = con.Event_Date__c;
                            //stCon.Personal_email__c = con.Personal_email__c;
                            // if(companyStAccMap.containsKey(con.Company_Name__c + con.Country__c))
                            // stCon.accountId = companyStAccMap.get(con.Company_Name__c + con.Country__c).id;
                            if(fuzzyMatchMap.containsKey(conCompCountryKey))
                                stCon.AccountId = fuzzyMatchMap.get(conCompCountryKey).Id;
                            upConList.add(stCon);
                            upConMap.put(emailStConMap.get(con.Email__c).id, stCon);
                        }
                        system.debug('upConMap ====> ' + upConMap);
                    } else if(!emailStConMap.containsKey(con.Email__c)) {
                        //Update contacts basis of Name and Country
                        if(con.FirstName__c != null && con.FirstName__c != '' && 
                           con.LastName__c != null && con.LastName__c != '' &&
                           con.Country__c != null && con.Country__c != '') {
                               if(nameCountryStConMap.containsKey(con.FirstName__c + con.LastName__c + con.Country__c) &&
                                  companyStAccMap.containsKey(con.Company_Name__c + con.Country__c)) {
                                      if(!upConMap.containsKey(nameCountryStConMap.get(con.FirstName__c + con.LastName__c + con.Country__c).id)) {
                                          Contact stCon = new Contact();
                                          stCon.id = nameCountryStConMap.get(con.FirstName__c + con.LastName__c + con.Country__c).id;
                                          stCon.firstname = con.FirstName__c;
                                          stCon.lastname = con.LastName__c;
                                          stCon.Secondary_Source__c = con.Secondary_Source__c;
                                          stCon.Opportunity_Source__c = con.Opportunity_Source__c;
                                          //stCon.Title = con.Title__c;
                                          stCon.Campaign_ID__c = con.Campaign_ID__c;
                                          stCon.Opportunity_Source__c = con.Opportunity_Source__c;
                                          stCon.Date_of_Incoming_Lead__c = con.Date_of_Incoming_Lead__c;
                                          stCon.Event_Date__c = con.Event_Date__c;
                                          //stCon.Personal_email__c = con.Personal_email__c;
                                          if(fuzzyMatchMap.containsKey(conCompCountryKey))
                                              stCon.accountId = fuzzyMatchMap.get(conCompCountryKey).id;
                                          upConList.add(stCon);
                                          upConMap.put(nameCountryStConMap.get(con.FirstName__c + con.LastName__c + con.Country__c).id, stCon);
                                      }
                                      system.debug('upConMap ====> ' + upConMap);
                                  } 
                           }
                    }
                    
                    //if contact not exists on basis of both emai and name+country
                    System.debug('emailStConMap.containsKey(con.Email__c)' + emailStConMap.containsKey(con.Email__c));
                    System.debug('nameCountryStConMap.containsKey(con.FirstName__c + con.LastName__c + con.Country__c)' + nameCountryStConMap.containsKey(con.FirstName__c + con.LastName__c + con.Country__c));
                    if(!emailStConMap.containsKey(con.Email__c) && !nameCountryStConMap.containsKey(con.FirstName__c + con.LastName__c + con.Country__c)) {
                        //If contact not present but account present
                        //if(companyStAccMap.containsKey(con.Company_Name__c + con.Country__c)) {
                        
                        if(fuzzyMatchMap.containsKey(conCompCountryKey)){
                            Contact stCon = new Contact();
                            stCon.firstname = con.FirstName__c;
                            stCon.lastname = con.LastName__c;
                            stCon.Secondary_Source__c = con.Secondary_Source__c;
                            stCon.Opportunity_Source__c = con.Opportunity_Source__c;
                            stCon.Title = con.Title__c;
                            stCon.Campaign_ID__c = con.Campaign_ID__c;
                            stCon.LinkedIn_Profile__c = con.LinkedIn_profile_URL__c;
                            stCon.Campaign_Name__c = con.Campaign_Name__c;
                            stCon.Country__c = con.Country__c;
                            stCon.Email = con.Email__c;
                            stCon.Personal_email__c = con.Personal_email__c;
                            stCon.AccountId = fuzzyMatchMap.get(conCompCountryKey).Id;
                            
                            insConList.add(stCon);
                            system.debug('insConList ====> ' + insConList);
                        }
                        else {
                            //If neither the contact or account is present
                            Account acc = new Account();
                            acc.Name = con.Company_Name__c;
                            acc.Country__c = con.Country__c;
                            acc.BillingCountry = con.Country__c;
                            
                            insAccList.add(acc);
                            system.debug('insAccList =====> ' + insAccList);
                            
                            Contact stCon = new Contact();
                            stCon.firstname = con.FirstName__c;
                            stCon.lastname = con.LastName__c;
                            stCon.Secondary_Source__c = con.Secondary_Source__c;
                            stCon.Opportunity_Source__c = con.Opportunity_Source__c;
                            stCon.Title = con.Title__c;
                            stCon.Campaign_ID__c = con.Campaign_ID__c;
                            stCon.LinkedIn_Profile__c = con.LinkedIn_profile_URL__c;
                            stCon.Campaign_Name__c = con.Campaign_Name__c;
                            stCon.Country__c = con.Country__c;
                            stCon.Company_Account_name__c = con.Company_Name__c;
                            stCon.Email = con.Email__c;
                            stCon.Personal_email__c = con.Personal_email__c;
                            
                            insConList.add(stCon);
                        }
                        system.debug('insConList ====> ' + insConList);
                    }
                }
            }
            
            //update contacts
            if(!upConMap.isEmpty()) {
                try {
                    system.debug('upConMap.values() ====> ' + upConMap.values());
                    update upConMap.values();
                } catch(Exception e) {
                    for(Contact eacjObject : upConMap.values()){
                        Leads_Failure__c leadFailureObj = new Leads_Failure__c();
                        leadFailureObj.Object_Type__c = 'Contact';
                        leadFailureObj.Error_Reason__c = e.getMessage();
                        leadFailureObj.Company_Name__c = eacjObject.FirstName + ' ' + eacjObject.LastName;
                        
                        lstLeadFailure.add(leadFailureObj);
                    }
                    system.debug('lstLeadFailure ===> ' + lstLeadFailure);
                    System.debug('exception : '+e.getMessage());
                    
                    if(lstLeadFailure != null && lstLeadFailure.size() > 0) {
                        //insert lstLeadFailure;
                    }
                }
            }
            
            //insert account
            Map<string, Account> insertedAccMap = new Map<string, Account>();
            
            if(insAccList != null && insAccList.size() > 0) {
                try {
                    insert insAccList;
                    system.debug('insAccList ===> ' + insAccList);
                    for(Account acc : insAccList) {
                        insertedAccMap.put(acc.Name + acc.Country__c, acc);
                    }
                } catch(Exception e) {
                    for(Account eachAcc : insAccList){
                        Leads_Failure__c leadFailureObj = new Leads_Failure__c();
                        leadFailureObj.Object_Type__c = 'Account';
                        leadFailureObj.Error_Reason__c = e.getMessage();
                        leadFailureObj.Company_Name__c = eachAcc.Name;
                        //leadFailureObj.Lead_Email__c = eachCon.Email;
                        //leadFailureObj.Lead_Name__c = eachCon.FirstName + eachCon.LastName;
                        lstLeadFailure.add(leadFailureObj);
                    }
                    system.debug('lstLeadFailure Account ====> ' + lstLeadFailure);
                    if(lstLeadFailure != null && lstLeadFailure.size() > 0) {
                        //insert lstLeadFailure;
                    }
                    System.debug('exception : '+e.getMessage());
                }
            }
            
            //insert contact
            if(insConList != null && insConList.size() > 0) {
                for(Contact con : insConList) {
                    if(con.AccountID == null && !insertedAccMap.isEmpty() && insertedAccMap.containsKey(con.Company_Account_name__c + con.Country__c)) {
                        con.accountId = insertedAccMap.get(con.Company_Account_name__c + con.Country__c).Id;
                    }
                }
                
                try {
                    insert insConList;
                    system.debug('insConList ===> ' + insConList);
                } catch(Exception e) {
                    for(Contact eachCon : insConList){
                        Leads_Failure__c leadFailureObj = new Leads_Failure__c();
                        leadFailureObj.Object_Type__c = 'Contact';
                        leadFailureObj.Error_Reason__c = e.getMessage();
                        leadFailureObj.Company_Name__c = eachCon.Company_Account_name__c;
                        leadFailureObj.Lead_Email__c = eachCon.Email;
                        leadFailureObj.Lead_Name__c = eachCon.FirstName + eachCon.LastName;
                        lstLeadFailure.add(leadFailureObj);
                    }
                    system.debug('lstLeadFailure Leads ====> ' + lstLeadFailure);
                    if(lstLeadFailure != null && lstLeadFailure.size() > 0) {
                        //insert lstLeadFailure;
                    }
                    System.debug('exception : '+e.getMessage());
                }
            }
            
            if(lstLeadFailure != null && lstLeadFailure.size() > 0) {
                insert lstLeadFailure;
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}