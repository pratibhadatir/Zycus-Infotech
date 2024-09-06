public class ActivityTriggerHandlers {
    private final String SUB_CATEGORY_EMAIL = 'EMAIL';
    private final String CONTACT_API = 'Contact';
    
    public void updateContactStatus(List<Task> taskList) {
        Set<Id> contactIdSet = getContactIds(taskList);
        List<Contact> contactList = [SELECT Contact_Status__c FROM Contact WHERE Id IN :contactIdSet];
        updateContacts(contactList);
    }
    
    private Set<Id> getContactIds(List<Task> taskList) {
        Set<Id> contactIdSet = new Set<Id>();
        for(Task t : taskList) {
            if(t.Sub_Category__c != null && (t.Sub_Category__c == SUB_CATEGORY_EMAIL)) {
                
                if(t.WhoId !=null )
                {
                    Id whoId = t.WhoId;
                    if(whoId.getSObjectType().getDescribe().getName() == CONTACT_API)
                    contactIdSet.add(whoId);
                }
            }
        }
        return contactIdSet;
    }
    
    private void updateContacts(List<Contact> contactList) {
        for(Contact con : contactList) {
            if(con.Contact_Status__c == 'Open - Not Contacted')
                con.Contact_Status__c = 'Open - Voicemail / Email';
        }
        update contactList;
    }
}