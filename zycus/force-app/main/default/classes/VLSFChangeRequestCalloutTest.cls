@isTest
public class VLSFChangeRequestCalloutTest {
    
    @isTest
    static void testCRInsert(){
        List<ChangeRequest> crList = new List<ChangeRequest>();
        Test.setMock(HttpCalloutMock.class, new VLSFCNS_JenkinsResponse());
        List<User> userId = [Select id,Name from User where Name ='Aadarsh Bhalerao']; 
        ChangeRequest testCR = new ChangeRequest(
                Subject = 'Test CR ',
                VLSF_Task_Team__c = 'SRE',
                VLSF_Initiator__c =userId[0].Id,
                VLSF_Team__c ='Certinal',
                Sub_Team__c='Certinal',
                VLSF_Assigned_To__c='Team_Certinal',
                VLSF_Severity__c = 'Critical',
                VLSF_Make_Jenkins_Callout__c = 'Yes',
                VLSF_Change_Type__c = 'Standard',
                Impact = 'Critical'
            );
        
        test.startTest();
        Insert testCR;
        test.stopTest();
        crList.add(testCR);
        
        String jsonStringCR = JSON.serializePretty(crList);
        VLSFChangeRequestApi.makeJenkinsCallout(jsonStringCR);
    }
    
    @isTest
    static void testCNS(){
        List<Id> crIds = new List<Id>();
        Test.setMock(HttpCalloutMock.class, new VLSFCNS_JenkinsResponse());
         List<User> userId = [Select id,Name from User where Name ='Aadarsh Bhalerao']; 
        ChangeRequest testCR = new ChangeRequest(
                Subject = 'Test CR ',
                VLSF_Task_Team__c = 'SRE',
                VLSF_Initiator__c =userId[0].Id,
                VLSF_Team__c ='Certinal',
                Sub_Team__c='Certinal',
                VLSF_Assigned_To__c='Team_Certinal',
                VLSF_Severity__c = 'Critical',
                VLSF_Change_Type__c = 'Major',
                Impact = 'Critical'
            );
        Insert testCR;
        
        test.startTest();
        testCR.VLSF_Change_Schedule_start_Date_Time__c = System.Now();
        Update testCR;
        test.stopTest();   
        crIds.add(testCR.Id);
        //VLSFChangeRequestApi.makeApiCalloutCNS(new Set<Id>(crIds));
        VLSFCalloutToCNS.makeCNSApiCallout(crIds);
    }
       
}