/* 
Trigger code to check if any EmailMessage is getting deleted related to Case, And restricts the deletion for all the users. 
*/

trigger VLSFRestrictEmailMessageDeletion on EmailMessage (before delete) {
    for(EmailMessage em:trigger.old)
    {
        if(em.ParentId != NULL) 														// checks if case is attached
        em.addError('Unable to delete email message: This action is not permitted.');	// restricts the deletion for case email messages.
    }

}