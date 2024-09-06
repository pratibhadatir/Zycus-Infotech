trigger Trg_CreateUpdateContact on Contact_Custom__c (before insert) {
	if(Trigger.isBefore && Trigger.isInsert) {
        //CreateUpdateContact_Handler.handleContacts(Trigger.new);
        CreateUpdateContact_HandlerBatch updateContact = new CreateUpdateContact_HandlerBatch(Trigger.new);
        Database.executeBatch(updateContact,200);
    }
}