@isTest
public class VLSFOpsgenieCalloutsTest {
      
    @isTest
    static void testEscalationP1Insert(){
        //For P1 Escalation Non-Event.
        List<Case> caseList = new List<Case>();
        Test.setMock(HttpCalloutMock.class, new VLSFOpsgenieResponseGenerator());
        String accName;
        List<Account> acc = [select Id from Account where Name = 'Internal' LIMIT 1];
        for(Account a: acc){
            accName = a.Id;    
        }
        Case testCase2 = new Case(
            Origin = 'Email',
            Subject = 'Test',
            AccountId= accName,
            Description = 'Test',
            VLSF_Region__c = 'EMEA',
            VLSF_Account_Support_Category_Type__c = 'Implementation',
            VLSF_Incident_Type__c = 'Incident',
            VLSF_Product__c = 'SIM',
            VLSF_Impact__c = 'High',
            VLSF_Prod_Staging__c = 'Production',
            VLSF_Picklist_Severity__c = 'Critical',
            VLSF_Team__c = 'Delivery',
            VLSF_Sub_Team__c = 'US-Upstream',
            VLSF_Assigned_To__c = 'Aadish Meghani'
            //VLSF_Priority__c = 'P1'
        
        );
        
        Test.startTest();
        insert testCase2;
        Test.stopTest();
        caseList.add(testCase2);
        system.debug('caseList...'+caseList);
        //System.assertEquals(1, Limits.getQueueableJobs());
        //Assert.areEqual('P1', testCase2.VLSF_Priority__c);
        
        String jsonStringCases = JSON.serializePretty(caseList);
        VLSFOpsgenieCallouts.OpsgenieEscalationCallout1(jsonStringCases);                   
    } 
    
     // Test method for Status Closed
    @isTest
    static void testCloseUpdate() {
        // Create a test Case record with required fields
        List<Case> caseList = new List<Case>();
        Test.setMock(HttpCalloutMock.class, new VLSFOpsgenieResponseGenerator());
        String accName;
        List<Account> acc = [select Id from Account where Name = 'Internal' LIMIT 1];
        for(Account a: acc){
            accName = a.Id;    
        }
        Case testCase = new Case(
            Origin = 'Event',
            AccountId= accName,
            VLSF_Opsgenie_Eacalated_Alert_Id__c = 'TestAlertId',
            Subject = 'Test',
            Description = 'Test',
            VLSF_Region__c = 'EMEA',
            VLSF_Account_Support_Category_Type__c = 'Implementation',
            VLSF_Incident_Type__c = 'Incident',
            VLSF_Product__c = 'SIM',
            VLSF_Prod_Staging__c = 'Production',
            VLSF_Impact__c = 'High',
            VLSF_Picklist_Severity__c = 'Critical',
            VLSF_Team__c = 'Delivery',
            VLSF_Sub_Team__c = 'US-Upstream',
            VLSF_Assigned_To__c = 'Ashish Singh'
        );
        insert testCase;

        Approval.unlock(testCase.Id);
        Test.startTest();
        // updating the test Case record, status = Close
                     
        //testCase.Case_Approval_Status__c = 'Approved';
        //testCase.Approval_Status__c = false;
        //testCase.VLSF_Approved__c = true;
        
        //update testCase;
        testCase.VLSF_Resolution_Code__c = 'Resolved - Pre Prod';
        testCase.VLSF_Resolution__c  = 'test';
        testCase.VLSF_Workaround_description__c = 'test';
        testCase.VLSF_Root_Cause_analysis__c = 'test';
        testCase.VLSF_Issue_escaped__c = 'External';
        testCase.VLSF_Track_Collateral_Damage__c = 'Yes';
        testCase.Reason_KA_not_attached__c = 'The knowledge article may not directly address the issue or question raised in the case. Attaching irrelevant articles can confuse users and waste their time.';
        testCase.Status = 'Resolved';
        update testCase;
        testCase.Status = 'Closed';
        Update testCase;
        caseList.add(testCase);
        String jsonStringCases = JSON.serializePretty(caseList);
        VLSFOpsgenieCallouts.OpsgenieStatusCloseCallout(jsonStringCases);
        Test.stopTest();
        
        //System.assertEquals(1, Limits.getQueueableJobs());
        testCase = [SELECT Status FROM Case WHERE Id = :testCase.Id];
        //Assert.areEqual('Closed', testCase.Status);
        
        
    }
   /* 
    @isTest
    static void testAck(){
        List<Case> caseList = new List<Case>();
        Test.setMock(HttpCalloutMock.class, new VLSFOpsgenieResponseGenerator());
        Case testCase = new Case(
            Origin = 'Event',            
            Subject = 'Test',
            Description = 'Test',
            VLSF_Region__c = 'EMEA',
            VLSF_Account_Support_Category_Type__c = 'Implementation',
            VLSF_Incident_Type__c = 'Incident',
            VLSF_Product__c = 'iPerform',
            VLSF_Impact__c = 'Critical',
            VLSF_Picklist_Severity__c = 'Critical',
            VLSF_Team__c = 'Delivery',
            VLSF_Sub_Team__c = 'US-Upstream',
            VLSF_Assigned_To__c = 'Aadarsh Bhalerao'
        );     
        insert testCase;

        Test.startTest();
        
        testCase.VLSF_Opsgenie_Alert_Id__c = 'TestAlertId';
        update testCase;    
        Test.stopTest();
        
        caseList.add(testCase);
        //System.assertEquals(1, Limits.getQueueableJobs());
        //Assert.areEqual('Closed', testCase.Status);
        
        String jsonStringCases = JSON.serializePretty(caseList);
        VLSFOpsgenieCallouts.OpsgenieAckCallout(jsonStringCases);
    }


    // Test method for Status Update
    @isTest
    static void testStatusUpdate() {
        // Create a test Case record with required fields
        List<Case> caseList = new List<Case>();
        Test.setMock(HttpCalloutMock.class, new VLSFOpsgenieResponseGenerator());
        Case testCase = new Case(
            Origin = 'Event',
            VLSF_Opsgenie_Alert_Id__c = 'TestAlertId1'
        );
        insert testCase;

        Test.startTest();
        // Cupdating the test Case record, status = Closed
        testCase.Status = 'In Progress';
        update testCase;
        Test.stopTest();
        
        //System.assertEquals(1, Limits.getQueueableJobs());
        Assert.areEqual('In Progress', testCase.Status);
        
        String jsonStringCases = JSON.serializePretty(caseList);
        VLSFOpsgenieCallouts.OpsgenieStatusCallout(jsonStringCases);
    }

    // Test method for P1 Escalation in Update
    @isTest
    static void testP1EscUpdate() {
        // Create a test Case record with required fields
        List<Case> caseList = new List<Case>();
        Test.setMock(HttpCalloutMock.class, new VLSFOpsgenieResponseGenerator());
        Case testCase = new Case(
            Origin = 'Email',
            Subject = 'P1 Escalation Salesforce',
            Description = 'P1 Escalation Salesforce'
        );
        insert testCase;

        Test.startTest();
        // Cupdating the test Case record, status = Closed        
        //testCase.VLSF_Priority__c = 'P1';
        //testCase.VLSF_Sub_Team__c = ;
        //testCase.Assigned_To__c = ;
        testCase.VLSF_Region__c = 'EMEA';
        testCase.VLSF_Account_Support_Category_Type__c = 'Implementation';
        testCase.VLSF_Incident_Type__c = 'Incident';
        testCase.VLSF_Product__c = 'iPerform';
        testCase.VLSF_Impact__c = 'Critical';
        testCase.VLSF_Picklist_Severity__c = 'Critical';
        testCase.VLSF_Team__c = 'Delivery';
        testCase.VLSF_Sub_Team__c = 'US-Upstream';
        testCase.VLSF_Assigned_To__c = 'Mayur Bhosale';
        update testCase;
        Test.stopTest();
        caseList.add(testCase);
        //System.assertEquals(1, Limits.getQueueableJobs());
        //Assert.areEqual('P1', testCase.VLSF_Priority_Formula__c);
        
        String jsonStringCases = JSON.serializePretty(caseList);
        VLSFOpsgenieCallouts.OpsgenieEscalationCallout1(jsonStringCases);
    }
  
    @isTest
    static void testDynatraceFailure(){
        List<Case> caseList = new List<Case>();
        //Test.setMock(HttpCalloutMock.class, new VLSFOpsgenieResponseGenerator());
        Case testCase = new Case(
            Origin = 'Event',            
            Subject = 'Test',
            Description = 'Web request service nodejs Failure rate increase 92.4 requests/min impacted by a failure rate increase to 1.38 % \nService method: All dynamic requests',
            VLSF_Region__c = 'EMEA',
            VLSF_Account_Support_Category_Type__c = 'Implementation',
            VLSF_Incident_Type__c = 'Incident',
            VLSF_Product__c = 'iPerform',
            VLSF_Impact__c = 'High',
            VLSF_Picklist_Severity__c = 'High',
            VLSF_Team__c = 'Delivery',
            VLSF_Sub_Team__c = 'US-Upstream',
            VLSF_Assigned_To__c = 'Aadarsh Bhalerao',
            VLSF_Opsgenie_Alert_Id__c = 'TestAlertId',
            opsgenie_alias__c ='TestAlertAlias'
        );     
        insert testCase;
        String priority;
        Test.startTest();
        // updating the description to change failure rate
        testCase.Description = 'Web request service nodejs Failure rate increase 92.4 requests/min impacted by a failure rate increase to 51.38 % \nService method: All dynamic requests';
        update testCase;
        Test.stopTest();
        caseList.add(testCase);
        if (!caseList.isEmpty()) {
            priority = caseList[0].VLSF_Priority__c; 
            system.debug('caseList..'+caseList);
            System.debug('Priority of the first record: ' + priority);
        }             
        system.debug('priority..'+priority);        
    }
    
     @isTest
    static void testP2EscUpdate() {
        // Create a test Case record with required fields
        List<Case> caseList = new List<Case>();
        Test.setMock(HttpCalloutMock.class, new VLSFOpsgenieResponseGenerator());
        Case testCase = new Case(
            Origin = 'Email',
            Subject = 'P2 Escalation Salesforce'
        );
        insert testCase;

        Test.startTest();
        // Cupdating the test Case record, status = Closed
        testCase.VLSF_Priority__c = 'P2';
        testCase.VLSF_Escalated1__c = true;
        testCase.VLSF_Incident_Type__c = 'Incident';
        update testCase;
        Test.stopTest();
        caseList.add(testCase);
        
        //System.assertEquals(1, Limits.getQueueableJobs());
        Assert.areEqual('P2', testCase.VLSF_Priority__c);
        Assert.areEqual(true, testCase.VLSF_Escalated1__c);
        
        String jsonStringCases = JSON.serializePretty(caseList);
        VLSFOpsgenieCallouts.OpsgenieEscalationCallout1(jsonStringCases);
    }
    
    @isTest
    static void testDynatraceFailure1(){
        List<Case> caseList = new List<Case>();
        //Test.setMock(HttpCalloutMock.class, new VLSFOpsgenieResponseGenerator());
        Case testCase = new Case(
            Origin = 'Event',            
            Subject = 'Test',
            Description = 'Web request service nodejs Failure rate increase 92.4 requests/min impacted by a failure rate increase to 1.38 % \nService method: All dynamic requests',
            VLSF_Region__c = 'EMEA',
            VLSF_Account_Support_Category_Type__c = 'Implementation',
            VLSF_Incident_Type__c = 'Incident',
            VLSF_Product__c = 'iPerform',
            VLSF_Impact__c = 'High',
            VLSF_Picklist_Severity__c = 'High',
            VLSF_Team__c = 'Delivery',
            VLSF_Sub_Team__c = 'US-Upstream',
            VLSF_Assigned_To__c = 'Aadarsh Bhalerao',
            VLSF_Opsgenie_Alert_Id__c = 'TestAlertId',
            opsgenie_alias__c ='TestAlertAlias'
        );     
        insert testCase;
        String priority;
        Test.startTest();
        // updating the description to change failure rate
        testCase.Description = 'Web request service nodejs Failure rate increase 92.4 requests/min impacted by a failure rate increase to 51.38 % \nService method: All dynamic requests';
        update testCase;
        Test.stopTest();
        caseList.add(testCase);
        if (!caseList.isEmpty()) {
            priority = caseList[0].VLSF_Priority__c; 
            system.debug('caseList..'+caseList);
            System.debug('Priority of the first record: ' + priority);
        }             
        system.debug('priority..'+priority);        
    }
    
     @isTest
    static void testDynatraceFailure2(){
        List<Case> caseList = new List<Case>();
        //Test.setMock(HttpCalloutMock.class, new VLSFOpsgenieResponseGenerator());
        Case testCase = new Case(
            Origin = 'Event',            
            Subject = 'Test',
            Description = 'Web request service nodejs Failure rate increase 92.4 requests/min impacted by a failure rate increase to 1.38 % \nService method: All dynamic requests',
            VLSF_Region__c = 'EMEA',
            VLSF_Account_Support_Category_Type__c = 'Implementation',
            VLSF_Incident_Type__c = 'Incident',
            VLSF_Product__c = 'iPerform',
            VLSF_Impact__c = 'High',
            VLSF_Picklist_Severity__c = 'High',
            VLSF_Team__c = 'Delivery',
            VLSF_Sub_Team__c = 'US-Upstream',
            VLSF_Assigned_To__c = 'Aadarsh Bhalerao',
            VLSF_Opsgenie_Alert_Id__c = 'TestAlertId',
            opsgenie_alias__c ='TestAlertAlias'
        );     
        insert testCase;
        String priority;
        Test.startTest();
        // updating the description to change failure rate
        testCase.Description = 'Web request service nodejs Failure rate increase 92.4 requests/min impacted by a failure rate increase to 31.38 % \nService method: All dynamic requests';
        update testCase;
        Test.stopTest();
        caseList.add(testCase);
        if (!caseList.isEmpty()) {
            priority = caseList[0].VLSF_Priority__c; 
            system.debug('caseList..'+caseList);
            System.debug('Priority of the first record: ' + priority);
        }             
        system.debug('priority..'+priority);        
    }
    
    @isTest
    static void testEscalationClose(){
        List<Case> caseList = new List<Case>();
        Test.setMock(HttpCalloutMock.class, new VLSFOpsgenieResponseGenerator());
        Case testCase = new Case(
            Origin = 'Email',            
            Subject = 'Test Close Escalation',
            Description = 'Web request service nodejs Failure rate increase 92.4 requests/min impacted',
            VLSF_Region__c = 'EMEA',
            VLSF_Account_Support_Category_Type__c = 'Implementation',
            VLSF_Incident_Type__c = 'Incident',
            VLSF_Product__c = 'iPerform',
            VLSF_Impact__c = 'High',
            VLSF_Picklist_Severity__c = 'High',
            VLSF_Team__c = 'Delivery',
            VLSF_Sub_Team__c = 'US-Upstream',
            VLSF_Assigned_To__c = 'Aadarsh Bhalerao',
            //VLSF_Opsgenie_Alert_Id__c = 'TestAlertId',
            //VLSF_Opsgenie_Alias__c ='TestAlertAlias'
            VLSF_Opsgenie_Eacalated_Alert_Id__c = 'TestAlertId',
            VLSF_Opsgenie_Eacalated_Alias__c = 'TestAlertId'
        );
        Insert testCase;
        
        Test.startTest();
        //updating the Escalated case for status = Closed
        testCase.Status = 'Closed';
        update testCase;
        Test.stopTest();
        caseList.add(testCase);
        
        String jsonStringCases = JSON.serializePretty(caseList);
        VLSFOpsgenieCallouts.OpsgenieStatusCloseCallout(jsonStringCases);
    }*/
    
    @isTest
    static void testVLSFEscalatedAlertId() {
        Test.setMock(HttpCalloutMock.class, new VLSFOpsgenieResponseGenerator());
        Map<Id, String> caseIdToRequestIdMap = new Map<Id, String>();
        String requestId = '43a29c5c-3dbf-4fa4-9c26-f4f71023e121';
        Case testCase = new Case(
            Origin = 'Email',            
            Subject = 'Test Close Escalation',
            Description = 'Web request service nodejs Failure rate increase 92.4 requests/min impacted',
            VLSF_Region__c = 'EMEA',
            VLSF_Account_Support_Category_Type__c = 'Implementation',
            VLSF_Incident_Type__c = 'Incident',
            VLSF_Product__c = 'iPerform',
            VLSF_Impact__c = 'High',
            VLSF_Picklist_Severity__c = 'Critical',
            VLSF_Team__c = 'Delivery',
            VLSF_Sub_Team__c = 'US-Upstream',
            VLSF_Assigned_To__c = 'Aadish Meghani'
            //VLSF_Opsgenie_Alert_Id__c = 'TestAlertId',
            //VLSF_Opsgenie_Alias__c ='TestAlertAlias'
            //VLSF_Opsgenie_Eacalated_Alert_Id__c = 'TestAlertId',
            //VLSF_Opsgenie_Eacalated_Alias__c = 'TestAlertId'
        );
        
        test.startTest();
        Insert testCase;
        test.stopTest();
        Approval.lock(testCase.Id);
        caseIdToRequestIdMap.put(testCase.Id,requestId);
        
        System.enqueueJob(new VLSFEscalatedAlertId(caseIdToRequestIdMap));
        
    } 
    @isTest
    Static void opsgenieCall(){
        Test.setMock(HttpCalloutMock.class, new VLSFOpsgenieResponseGenerator());
        List<Case> listCase = new List<Case>();
         Case testCase = new Case(
            Origin = 'Event',            
            Subject = 'Test',
            Description = 'Test',
            VLSF_Region__c = 'EMEA',
            VLSF_Account_Support_Category_Type__c = 'Implementation',
            VLSF_Incident_Type__c = 'Incident',
            VLSF_Product__c = 'SIM',
            VLSF_Prod_Staging__c = 'Production',
            VLSF_Impact__c = 'High',
            VLSF_Picklist_Severity__c = 'Critical',
            VLSF_Team__c = 'Delivery',
            VLSF_Sub_Team__c = 'US-Upstream',
            VLSF_Assigned_To__c = 'Aadish Meghani',
            opsgenie_alias__c = 'testAlias' 
        );     
        Insert testCase;
        String endpoint = 'https://api.opsgenie.com/v1/json/integrations/webhooks/salesforceservicecloud?apiKey=d1de5d37-0540-4421-aaaa-ac1c5fed7dc4';
        string payload= '{'+
                    '\"id\" :' + testCase.id+ ',' +
                    '\"caseNumber\" :' + testCase.caseNumber+ ',' +
                    '\"priority\" :' + testCase.priority+ ',' +
                    '\"status\" :' + testCase.status+ ',' +
                    '\"origin\" :' + testCase.origin+ ',' +
                    '\"subject\" :' + testCase.subject+ ',' +
                    '\"description\" :' + testCase.description+ ',' +
                    '\"closedDate\" :' + testCase.closedDate+ ',' +
                    '\"createdDate\" :' + testCase.createdDate+ ',' +
                                '}';
        String payload2 = '{'+
                    '\"ep\" :https://api.opsgenie.com/v2/alerts/' + EncodingUtil.urlEncode(testCase.opsgenie_alias__c, 'UTF-8') + '/acknowledge ,' +
                    '\"note\" :Case Number ' + testCase.caseNumber +',' +
                    	          '}';
        
        String jsonStringCases = JSON.serializePretty(listCase); 
        
        test.startTest();
        VLSFOpsgenieCallouts.xRESTCall(endpoint,endpoint);
        VLSFOpsgenieCallouts.xAckAlert(payload2); 
        test.stopTest();        
    }
    
     @isTest
    static void testGetPayloadStringByHandlingNull() {
        // Testing the string handling method
        String nullString = null;
        String validString = 'Hello, World!';
        System.assertEquals(null, VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(nullString));
        System.assertEquals('"Hello World"', VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(validString));

        // Testing the DateTime handling method
        DateTime nullDateTime = null;
        DateTime validDateTime = DateTime.newInstance(2023, 5, 1, 12, 0, 0);
        System.assertEquals(null, VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(nullDateTime));
        System.assertEquals('"' + validDateTime + '"', VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(validDateTime));

        // Testing the Decimal handling method
        Decimal nullDecimal = null;
        Decimal validDecimal = 123.45;
        System.assertEquals(null, VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(nullDecimal));
        System.assertEquals('"123.45"', VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(validDecimal));

        // Testing the Boolean handling method
        Boolean nullBoolean = null;
        Boolean validBoolean = true;
        System.assertEquals(null, VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(nullBoolean));
        System.assertEquals('"true"', VLSFOpsgenieCallouts.getPayloadStringByHandlingNull(validBoolean));
    }
}