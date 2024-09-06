public class VLSFChangeRequestHandler {
    public static void handleAfterInsert(List<ChangeRequest> newChangeRequests) {
        List<Task> tasksToInsert = new List<Task>();
        try{
            Map<String, Id> queueNameToIdMap = new Map<String, Id>();
            for (Group queue : [SELECT Id, Name FROM Group WHERE Type ='Queue']) {
                queueNameToIdMap.put(queue.Name, queue.Id);
            }
            
            // Retrieve existing tasks based on OwnerId
            Set<Id> existingTaskOwnerIds = new Set<Id>();
            for (Task existingTask : [SELECT OwnerId,VLSF_Task_Created__c FROM Task WHERE WhatId IN :newChangeRequests]) {
                existingTaskOwnerIds.add(existingTask.OwnerId);
            }
            
            for (ChangeRequest cr : newChangeRequests) {
                if (cr.VLSF_Task_Team__c != null) {
                    // Split the multi-select picklist values
                    List<String> values = cr.VLSF_Task_Team__c.split(';');
                    
                    for (String value : values) {
                       
                        // Check if task with same OwnerId exists
                        if (!existingTaskOwnerIds.contains(queueNameToIdMap.get(value.trim()))) {
                            // Create a task
                            Task task = new Task();
                            task.Subject = cr.Subject;
                            task.WhatId = cr.Id; // Link task to Change Request
                            task.VLSF_Change_Schedule_start_Date_Time__c = cr.VLSF_Change_Schedule_start_Date_Time__c; 
                            task.VLSF_Change_Schedule_end_Date_Time__c = cr.VLSF_Change_Schedule_end_Date_Time__c;
                            task.Description = cr.Description;
                            //task.Priority = cr.Priority;
                            //task.VLSF_Severity__c = cr.VLSF_Severity__c;
                           // task.VLSF_Impact__c = cr.Impact;
                            task.Status = 'OPENED';
                            task.VLSF_Task_Created__c =True;
                            
                            // Assign OwnerId based on Queue
                            if (queueNameToIdMap.containsKey(value.trim())) {
                                task.OwnerId = queueNameToIdMap.get(value.trim());
                            }
                            
                            tasksToInsert.add(task);
                            //existingTaskSubjects.add(taskSubject); // Add subject to existing tasks
                        }
                    }
                }
            }
            // Insert tasks
            if (!tasksToInsert.isEmpty()) {
               insert tasksToInsert;
               System.debug('List of tasksToInsert: ' + tasksToInsert);
            }
        } catch (Exception e) {
            System.debug('An error occurred: ' + e.getMessage());
            // Handle the exception accordingly, e.g., logging the error or sending an email notification.
        }
        }
    }