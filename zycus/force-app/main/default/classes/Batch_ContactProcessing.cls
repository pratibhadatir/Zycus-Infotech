/*
 * Author - Radhe Shyam (rshyam@kloudrac.com)
 * Date - oct 19, 2022
 * Desc : This batch will do the contact mappings coming from Contact Staging table, do the mapping with Accounts after checking certain matching rules.
 */ 
global class Batch_ContactProcessing implements Database.Batchable<sObject>,Database.Stateful {
    global integer processedRecordCount =0;
    global List<Contact_Custom__c> lstStagingContactProcessed = new List<Contact_Custom__c>();
    global Set<Id> setContactId = new Set<Id>();
    global integer contactCounter =0;
    //Batch Size 1000
    global Iterable<SObject> start(Database.BatchableContext BC) {
       //Query on Accounts
      String contactQuery = 'Select id,NameCountry_Key__c , FirstName,LastName, Email from Contact Limit 2000000';
      return Database.getQueryLocator(contactQuery); 
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope) {
        
       // Matching logic will go here for 
       //List<Contact_Custom__c> lstStagingContacts = new List<Contact_Custom__c>([Select id, Name from Contact_Custom__c where Is_Processed__c =false order by createddate desc Limit 100]);
        
       //Further Logic - Run the outer loop on scope--> Run Inner loop on Contact_Custom__c--> inside inner loop check the matching logic, 
       //If staging contact match with record/new creation/updation happen ---> Mark the 'lstStagingContacts' records with Is_Processed__c=true and add in List, do not update
       //Once all batches will be completed, these 100 staging contacts will be matched will all 90K accounts and can be marked as Processed=true in the Finish method.
       List<Contact_Custom__c> lstCC = new List<Contact_Custom__c>([Select id,Company_Name__c, NameCountry_Key__c, Email__c,Personal_email__c,
                                                        Secondary_Source__c ,FirstName__c ,LastName__c , Name from Contact_Custom__c where Is_Processed__c =false order by createddate desc Limit 10]);
        for(Contact eachContact : scope){
            for(Contact_Custom__c stgCont : lstCC){
              
                   //Oset<String> dbemail = new set<String>();
                    //setContactId.add(eachContact.id); 
                contactCounter=contactCounter+1;
                
                                                            
                                                            
                                                            
                    //do the matching here, prepare list/set/map whatever is needed.
               /*if(!String.isBlank(eachContact.Email) && !String.isBlank(stgCont.Email__c) && (eachContact.Email).equalsIgnoreCase(stgCont.Email__c) && (stgCont.Email__c).contains('@')){
                   //Copy the Staging contact Data to Contact Record. i.e. Update.
					                                                                
				}*/	
                 
              
               //Keep the below code running
              // updateProcessed(stgCont);
            }
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC) {
        //if(lstStagingContactProcessed!=null && lstStagingContactProcessed.size()>0){
            //update lstStagingContactProcessed;
        //}
        
       // System.debug('Processed Records Count after completion of all batches lstStagingContactProcessed :  '+lstStagingContactProcessed.size());
        System.debug('Total Count on Contact : '+ contactCounter);
        
    }
   /* public void updateProcessed(Contact_Custom__c eachStagingContact){
          	processedRecordCount++;
         	Contact_Custom__c sC = new Contact_Custom__c(id=eachStagingContact.id);  
            sC.Is_Processed__c = true;
            lstStagingContactProcessed.add(sC);
    }*/
}