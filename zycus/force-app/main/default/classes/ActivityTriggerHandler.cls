public class ActivityTriggerHandler {
    private final String SUB_CATEGORY_CALL = 'Call';
    private final String SUB_CATEGORY_UPDATE = 'Update';
    private final String CONTACT_API = 'Contact';
    
    public void updateCallCount(List<Task> taskList) {
        Set<Id> contactIdSet = getContactIds(taskList);
        List<Contact> contactList = [SELECT Call_Count__c FROM Contact WHERE Id IN :contactIdSet];
        updateContacts(contactList);
    }
    
    private Set<Id> getContactIds(List<Task> taskList) {
        Set<Id> contactIdSet = new Set<Id>();
        for(Task t : taskList) {
            if(t.Sub_Category__c != null && ( t.Sub_Category__c == SUB_CATEGORY_CALL || t.Sub_Category__c == SUB_CATEGORY_UPDATE)) {
                
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
            if(con.Call_Count__c == NULL || con.Call_Count__c == 0)
                con.Call_Count__c = 1;
            else if(con.Call_Count__c >= 1)
                con.Call_Count__c = con.Call_Count__c + 1;
        }
        update contactList;
    }
}