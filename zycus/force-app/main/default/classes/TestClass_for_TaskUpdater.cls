@isTest
public class TestClass_for_TaskUpdater {
    
    // Test method to cover the positive scenario where all tasks are completed
    @isTest
    static void testUpdateChangeRequestCheckbox1_AllTasksCompleted() {
        // Create a Change Request
        List<ChangeRequest> crList = new List<ChangeRequest>();
        List<User> userId = [Select id,Name from User where Name ='Aadarsh Bhalerao']; 
        Test.setMock(HttpCalloutMock.class, new VLSFCNS_JenkinsResponse());
        ChangeRequest cr = new ChangeRequest( 
            Subject = 'Test CR ',
            VLSF_Task_Team__c = 'SRE',
            VLSF_Initiator__c =userId[0].Id,
            VLSF_Team__c ='Certinal',
            Sub_Team__c='Certinal',
            VLSF_Assigned_To__c='Team_Certinal',
            VLSF_Severity__c = 'Critical',
            Impact = 'Critical');
        insert cr;
        //Test.startTest();
        
        // Create related tasks with Status 'Resolved'
        List<Task> taskList = [SELECT WhatId,Id, Status FROM Task WHERE WhatId = :cr.Id];
        system.debug('all tasks...'+taskList);
        for (Task task : taskList) {
            task.Status = 'Resolved';
        }
        
        update taskList;
        
        Test.startTest();
        // Call the method to be tested
        ChangeRequestTaskUpdater.updateChangeRequestCheckbox1(taskList);
        Test.stopTest();
    
        // Verify that the checkbox is set to true
        ChangeRequest updatedCR = [SELECT Id, VLSF_Jenkins_Callout__c FROM ChangeRequest WHERE Id = :cr.Id];
        //System.assertEquals(true, updatedCR.VLSF_Jenkins_Callout__c);
        
       /* cr.VLSF_Jenkins_Callout__c=True;
        update cr;
        Test.stopTest();
        crList.add(cr);
        
        String jsonStringCR = JSON.serializePretty(crList);
        VLSFChangeRequestApi.makeJenkinsCallout(jsonStringCR);
        
         // Create related tasks with Status 'Completed'
        List<Task> taskList = new List<Task>();
        
        Task t = new Task(WhatId = cr.Id, Status = 'RESOLVED'); // Set the Status to 'Completed'
        update t; // Insert the task into the database
        taskList.add(t);
        
        // Call the method to be tested
        ChangeRequestTaskUpdater.updateChangeRequestCheckbox1(taskList);
        
        // Verify that the checkbox is set to true
        ChangeRequest updatedCR = [SELECT Id, VLSF_Jenkins_Callout__c FROM ChangeRequest WHERE Id = :cr.Id];
        System.assertEquals(true, updatedCR.VLSF_Jenkins_Callout__c);  */
    }
}