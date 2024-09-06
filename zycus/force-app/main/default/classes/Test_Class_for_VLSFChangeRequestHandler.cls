@isTest
public class Test_Class_for_VLSFChangeRequestHandler {
     
    @isTest
    static void testHandleAfterInsert() {
        // Create test data for ChangeRequest
        List<ChangeRequest> changeRequests = new List<ChangeRequest>();
        for(Integer i = 0; i < 5; i++) {
            ChangeRequest cr = new ChangeRequest(
                Subject = 'Test CR ' + i,
                VLSF_Task_Team__c = 'SRE',
                VLSF_Change_Schedule_start_Date_Time__c = System.now(),
                VLSF_Change_Schedule_end_Date_Time__c = System.now().addDays(1),
                Description = 'Test Description ' + i,
                Priority = 'P1',
                VLSF_Severity__c = 'Critical',
                Impact = 'Critical'
            );
            changeRequests.add(cr);
        }
        insert changeRequests;
        
        // Create test data for Group (Queue)
        Group queue1 = new Group(Name = 'Queue1', Type = 'Queue');
        insert queue1;
        
        // Call the handleAfterInsert method
        Test.startTest();
        VLSFChangeRequestHandler.handleAfterInsert(changeRequests);
        Test.stopTest();
        
        // Verify that tasks are created
        List<Task> tasks = [SELECT Id, Subject, WhatId,Priority,VLSF_Change_Schedule_start_Date_Time__c, VLSF_Change_Schedule_end_Date_Time__c, Description, OwnerId 
                            FROM Task WHERE WhatId IN :changeRequests];
        
        System.assertEquals(5, tasks.size(), 'Incorrect number of tasks created');
        
        // Verify task fields
        for(Integer i = 0; i < tasks.size(); i++) {
            Task task = tasks[i];
            ChangeRequest cr = changeRequests[i];
            
            System.assertEquals('Test CR ' + i, task.Subject);
            System.assertEquals(cr.Id, task.WhatId);
            System.assertEquals(cr.VLSF_Change_Schedule_start_Date_Time__c, task.VLSF_Change_Schedule_start_Date_Time__c);
            System.assertEquals(cr.VLSF_Change_Schedule_end_Date_Time__c, task.VLSF_Change_Schedule_end_Date_Time__c);
            System.assertEquals('Test Description ' + i, task.Description);
            //System.assertEquals('P1', task.Priority);
            //System.assertEquals('Critical', task.VLSF_Severity__c);
            //System.assertEquals('Critical', task.VLSF_Impact__c);
            
          
        }
    }
}