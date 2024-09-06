public class setOwnerName {
    //Below method also fullfill the purpose of setting product name.
    public static void updateOwnerName(String taskNumber){
        
         BMCServiceDesk__Task__c[]  task   = [Select OwnerId ,BMCServiceDesk__taskDescription__c,BMCServiceDesk__FKRelease__c From BMCServiceDesk__Task__c where name =:taskNumber limit 1 ];
        if(task.size()>0){
            System.debug('Size > 0');
            if(task[0].BMCServiceDesk__taskDescription__c == 'Set up CAB meeting') {
               task[0].OwnerId = StatusUpdate.getIdForQueue('PDT-PMG'); 
               task[0].isSetNewQueueName__c = true;
                
                System.debug('Owner ID is Changed For the task: Set up CAB meeting');
             }
            else if(task[0].BMCServiceDesk__taskDescription__c == 'PEG MIS to start measuing the adoption of the feature in 30-60-90') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('PEG MIS');  
                task[0].isSetNewQueueName__c = true;
                
                System.debug('Owner ID is Changed For the task: PEG MIS to start measuing the adoption of the feature in 30-60-90');              
            }
             else if(task[0].BMCServiceDesk__taskDescription__c == 'Develop the release') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('PMG');  
                task[0].isSetNewQueueName__c = true;
                
                System.debug('Owner ID is Changed For the task: PEG MIS to start measuing the adoption of the feature in 30-60-90');              
            }
        
        	
          else if(task[0].BMCServiceDesk__taskDescription__c == 'Project team to discuss the Release in MBR\'s along with a  case study about the impact of the release') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('Delivery Team');  
              task[0].isSetNewQueueName__c = true;
              	  
                System.debug('Owner ID is Changed For the task: Project team to discuss the Release in MBR\'s along with a case study about the impact of the release');              
             }
             
          else if(task[0].BMCServiceDesk__taskDescription__c == 'Deploy the release on sandbox') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('PDTRM');      
                task[0].isSetNewQueueName__c = true; // task[0].newQueueName__c = 'PDTRM';
                System.debug('Owner ID is Changed For the task: Deploy the release on sandbox');               
             }
             
          else if(task[0].BMCServiceDesk__taskDescription__c == 'Release specific configuration on sandbox') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('App-Management');      
                  task[0].isSetNewQueueName__c = true; //task[0].newQueueName__c = 'App-Management';
                System.debug('Owner ID is Changed For the task: Release specific configuration on sandbox');               
             }
             
          else if(task[0].BMCServiceDesk__taskDescription__c == 'Train the SPOCs,University,Support team') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('PDT-PMG');     
              	 task[0].isSetNewQueueName__c = true;  //task[0].newQueueName__c = 'PDT-PMG';
                System.debug('Owner ID is Changed For the task: Train the SPOCs,University,Support team');               
             }
             
          else if(task[0].BMCServiceDesk__taskDescription__c == 'Test the release on Sandbox') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('PDT QA');      
               	 task[0].isSetNewQueueName__c = true; //task[0].newQueueName__c = 'PDT QA';
                System.debug('Owner ID is Changed For the task: Test the release on Sandbox');               
             }
             
          else if(task[0].BMCServiceDesk__taskDescription__c == 'Perform UAT') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('UAT Team');      
              	 task[0].isSetNewQueueName__c = true; //task[0].newQueueName__c = 'UAT Team';
                System.debug('Owner ID is Changed For the task: Perform UAT');               
             }
             
           else if(task[0].BMCServiceDesk__taskDescription__c == 'Fit for release') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('PDTRM');      
                 task[0].isSetNewQueueName__c = true; // task[0].newQueueName__c = 'PDTRM';
                System.debug('Owner ID is Changed For the task: Fit for release');               
             }
             
           else if(task[0].BMCServiceDesk__taskDescription__c == 'RM to review failure') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('PDTRM');      
                 task[0].isSetNewQueueName__c = true; //	task[0].newQueueName__c = 'PDTRM';
                System.debug('Owner ID is Changed For the task: RM to review the failure');               
             }
             
           else if(task[0].BMCServiceDesk__taskDescription__c == 'University to start customer training') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('Zycus Training');      
                task[0].isSetNewQueueName__c = true; // task[0].newQueueName__c = 'Zycus Training';
                System.debug('Owner ID is Changed For the task: University to start customer training');               
             }
             
           else if(task[0].BMCServiceDesk__taskDescription__c == 'Validate the App-Support deliverables') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('App-Support');      
                 task[0].isSetNewQueueName__c = true; // task[0].newQueueName__c = 'App-Support';
                System.debug('Owner ID is Changed For the task: Validate the App-Support deliverables');               
             }
             
           else if(task[0].BMCServiceDesk__taskDescription__c == 'Validate the App-Management deliverables') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('App-Management');      
                  task[0].isSetNewQueueName__c = true;// task[0].newQueueName__c = 'App-Management';
                System.debug('Owner ID is Changed For the task: Validate the App-Management deliverables');               
             }
             
           else if(task[0].BMCServiceDesk__taskDescription__c == 'Validate the Demo-Support deliverables') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('Demo Support');      
                task[0].isSetNewQueueName__c = true; // task[0].newQueueName__c = 'Demo Support';
                System.debug('Owner ID is Changed For the task: Validate the Demo-Support deliverables');               
             }
             
           else if(task[0].BMCServiceDesk__taskDescription__c == 'Validate the GO-DBA deliverables') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('GO-DBA');      
                 task[0].isSetNewQueueName__c = true; // task[0].newQueueName__c = 'GO-DBA';
                System.debug('Owner ID is Changed For the task: Validate the GO-DBA deliverables');               
             }
             
           else if(task[0].BMCServiceDesk__taskDescription__c == 'Validate the GO-IT deliverables') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('GO-IT');      
                	 task[0].isSetNewQueueName__c = true; //task[0].newQueueName__c = 'GO-IT';
                System.debug('Owner ID is Changed For the task: Validate the GO-IT deliverables');               
             }
             
            else if(task[0].BMCServiceDesk__taskDescription__c == 'Validate the Tech Support deliverables') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('Tech-Support');      
                task[0].isSetNewQueueName__c = true; //task[0].newQueueName__c = 'Tech-Support';                
                System.debug('Owner ID is Changed For the task: Validate the Tech Support deliverables');               
             }
             
           else if(task[0].BMCServiceDesk__taskDescription__c == 'Certification of Support teams, Consultants and Project teams') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('Zycus Training');      
                	 task[0].isSetNewQueueName__c = true; //task[0].newQueueName__c = 'Zycus Training';
                System.debug('Owner ID is Changed For the task: Certification of Support teams, Consultants and Project teams');               
             }
             
           else if(task[0].BMCServiceDesk__taskDescription__c == 'Put up Pre - upgrade Notification') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('Tech-Support');      
               	  task[0].isSetNewQueueName__c = true; //task[0].newQueueName__c = 'Tech-Support';
                System.debug('Owner ID is Changed For the task: Put up Pre- upgrade Notification');               
             }
             
           else if(task[0].BMCServiceDesk__taskDescription__c == 'Deploy the release on Demo') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('Demo Support');      
               task[0].isSetNewQueueName__c = true; //	task[0].newQueueName__c = 'Demo Support';
                System.debug('Owner ID is Changed For the task: Deploy the release on Demo');               
             }
             
            else if(task[0].BMCServiceDesk__taskDescription__c == 'Deploy the release on Prod') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('App-Support');      
              task[0].isSetNewQueueName__c = true;  //  task[0].newQueueName__c = 'App-Support';
                System.debug('Owner ID is Changed For the task: Deploy the release on Prod');               
             }
             
            else if(task[0].BMCServiceDesk__taskDescription__c == 'Post Upgrade Notification setup') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('Tech-Support');      
                task[0].isSetNewQueueName__c = true; // task[0].newQueueName__c = 'Tech-Support';
                System.debug('Owner ID is Changed For the task: Post Upgrade Notification setup');               
             }
        	else if(task[0].BMCServiceDesk__taskDescription__c == 'Provide upgrade plan to release group') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('App-Support');      
                task[0].isSetNewQueueName__c = true; // task[0].newQueueName__c = 'Tech-Support';
                System.debug('Owner ID is Changed For the task: Post Upgrade Notification setup');               
             }
            else if(task[0].BMCServiceDesk__taskDescription__c == 'Update application configuration CMDB') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('App-Management');      
               task[0].isSetNewQueueName__c = true; //  task[0].newQueueName__c = 'App-Management';
                System.debug('Owner ID is Changed For the task: Update application configuration CMDB');               
             }
        
      	 	else if(task[0].BMCServiceDesk__taskDescription__c == 'Update application CMDB') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('App-Support');      
                task[0].isSetNewQueueName__c = true;  // task[0].newQueueName__c = 'GO-DBA';
                System.debug('Owner ID is Changed For the task: Update database CMDB');               
             }
             
            else if(task[0].BMCServiceDesk__taskDescription__c == 'Update database CMDB') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('GO-DBA');      
                task[0].isSetNewQueueName__c = true;  // task[0].newQueueName__c = 'GO-DBA';
                System.debug('Owner ID is Changed For the task: Update database CMDB');               
             }
             
            else if(task[0].BMCServiceDesk__taskDescription__c == 'Update Infra CMDB') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('GO-IT');      
               task[0].isSetNewQueueName__c = true;  // task[0].newQueueName__c = 'GO-IT';
                System.debug('Owner ID is Changed For the task: Update Infra CMDB');               
             }
             
            else if(task[0].BMCServiceDesk__taskDescription__c == 'PEG MIS to start measuing the adoption of the feature in 30-60-90 ') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('PEG');      
                task[0].isSetNewQueueName__c = true;  // task[0].newQueueName__c = 'PEG';
                System.debug('Owner ID is Changed For the task: PEG MIS to start measuing the adoption of the feature in 30-60-90 ');               
             }
             
            else if(task[0].BMCServiceDesk__taskDescription__c == 'Installation on pre-prod') {
                task[0].OwnerId = StatusUpdate.getIdForQueue('App-Management');      
                task[0].isSetNewQueueName__c = true;  // task[0].newQueueName__c = 'App-Management';
                System.debug('Owner ID is Changed For the task: Installation on pre-prod');               
             }
            
            BMCServiceDesk__Release__c[]  release   = [Select Product__c From BMCServiceDesk__Release__c r where r.id =:task[0].BMCServiceDesk__FKRelease__c];
            if(release.size()>0){
                 task[0].Product__c = release[0].Product__c;
                   try{
               // TriggerFlag.setUpdateFlag(); //This was not allowing update trigger to get called.  
                    update task ;   
                }
                Catch(Exception e){
                    System.debug('Getting error' + e.getMessage());     
                }
            }
           
           	
            
             /*updating product fetched from Release */
        	
        
           
        }
     	   
         	
    }

     
}