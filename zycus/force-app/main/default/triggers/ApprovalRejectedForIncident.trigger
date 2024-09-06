trigger ApprovalRejectedForIncident on BMCServiceDesk__Incident__c (after update) {
       System.debug('ApprovalRejectedForIncident starts');  
	   String rejectedID = StatusUpdate.getIdForStatus('Rejected');	    
       String incId ;
       if (Trigger.isUpdate) {
            for (BMCServiceDesk__Incident__c inc : Trigger.new) {
              
               
                if(inc.BMCServiceDesk__FKStatus__c!=rejectedID && inc.ApprovalRejected__c==true ){
                    System.debug('In if and status is not rejected');
                    incId = inc.Name ;
                    StatusUpdate.updateStatusAsRejected(incId); 
                }
            }     
           
       }
      System.debug('ApprovalRejectedForIncident ends'); 
}