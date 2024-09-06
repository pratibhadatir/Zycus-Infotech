public class VLSFChangeRequestApi {
    
    @future(callout=true)
    public static void makeJenkinsCallout(String changeRequests){
        List<ChangeRequest> crs = new List<ChangeRequest>();
        String recordNumber;
        if(changeRequests != null) {
            crs = (List<ChangeRequest>) JSON.deserialize(changeRequests, List<ChangeRequest>.class);
            system.debug('case deserialize...'+crs);
        }
        String endpointUrl = getEndpointUrlFromMetadata();
        Map<String, String> headers = getHeadersFromMetadata();
        Map<String, object> valuesMap = new Map<String, object>();        
        
        if (!crs.isEmpty()) {
            // Construct payload
            List<Map<String, Object>> payloadList = new List<Map<String, Object>>();
            for (ChangeRequest cr : crs) {
                Map<String, Object> escalationBody = new Map<String, Object>();
                escalationBody.put('Subject', cr.Subject);
                escalationBody.put('Description', cr.Description);
                escalationBody.put('Priority', cr.Priority);
                escalationBody.put('Change_Category', cr.VLSF_Change_Category__c);
                 recordNumber = cr.ChangeRequestNumber;
                
                for(string str : valuesMap.keyset()){
                    escalationBody.put(str, cr.get(string.valueOf(valuesMap.get(str))));
                }
                payloadList.add(escalationBody);
            }
            
            // Serialize payload once
            String payloadJson = JSON.serialize(payloadList);
            System.debug('payloadJson...'+payloadJson); 
            
            // Perform the callout
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpointUrl);
            req.setMethod('POST');
            req.setBody(payloadJson);
            
            // Set headers
            for (String key : headers.keySet()) {
                req.setHeader(key, headers.get(key));
            }
            
            // Perform the callout
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            // Handle the response
            if (res.getStatusCode() == 200) {
                // Success
                System.debug('Jenkins API callout successful');
                //Store Success Log
                VLSF_ExceptionLog.SuccessLog(res.getBody(), recordNumber); // Change null to appropriate record identifier if available
            } else {
                // Handle error
                System.debug('Jenkins API callout failed with status code: ' + res.getStatusCode());
                System.debug('Response body: ' + res.getBody());
            }
        } else {
            System.debug('No Change Requests provided.');
        }
    }
    
    
    // Method to retrieve endpoint URL from custom metadata
    private static String getEndpointUrlFromMetadata() {
        try {
            // Query custom metadata to retrieve endpoint URL
            VLSF_Custom_Metadata_for_Api_Callout__mdt metadata = [SELECT VLSF_Endpoint_Api__c FROM VLSF_Custom_Metadata_for_Api_Callout__mdt LIMIT 1];
            return metadata.VLSF_Endpoint_Api__c;
        } catch (Exception e) {
            System.debug('Error retrieving endpoint URL from custom metadata: ' + e.getMessage());
            return null;
        }
    }
    
    // Method to retrieve headers from custom metadata
    private static Map<String, String> getHeadersFromMetadata() {
        Map<String, String> headers = new Map<String, String>();
        try {
            // Query custom metadata to retrieve headers
            List<VLSF_Custom_Metadata_for_Api_Callout__mdt> metadataList = [SELECT VLSF_Header_Key__c, VLSF_Header_Value__c FROM VLSF_Custom_Metadata_for_Api_Callout__mdt];
            for (VLSF_Custom_Metadata_for_Api_Callout__mdt metadata : metadataList) {
                headers.put(metadata.VLSF_Header_Key__c, metadata.VLSF_Header_Value__c);
            }
        } catch (Exception e) {
            System.debug('Error retrieving headers from custom metadata: ' + e.getMessage());
        }
        return headers;
    }
    
    
    // Method to perform CNS API callout
    @future(callout=true)
    public static void makeApiCalloutCNS(Set<Id> changeRequestIDs) {
        try{
            // Retrieve endpoint API and headers from custom metadata
            String endpointUrl = getEndpointUrlFromMetadataCNS();
            Map<String, object> valuesMap = new Map<String, object>();        
            Map<String, Object> details = new Map<String, Object>();
            Map<String, String> headers = getHeadersFromMetadataCNS();
            String recordNumber;
            
            
            List<Map<String, Object>> payloadList = new List<Map<String, Object>>();
            
            // Query for metadata records outside the loop
            VLSF_CNS_Custom_MetaData__mdt metadataRecords = [SELECT VLSF_Mapping__c FROM VLSF_CNS_Custom_MetaData__mdt where  label = 'CNS Record' LIMIT 1];
            
            if (metadataRecords != null) {
                // Deserialize metadata once
                // List<Object> metadataList = (List<Object>)JSON.deserializeUntyped(metadataRecords.VLSF_Mapping__c);
                for(Object obj : (List<Object>)JSON.deserializeUntyped(metadataRecords.VLSF_Mapping__c)){
                    //convert values to map
                    Map<String, Object> data = (Map<String, Object>)obj;
                    valuesMap.putAll(data);
                }
                System.debug(details); // 'Name';
                // Iterate over change requests to construct payload
                List<ChangeRequest> crQuery = [Select Id,BusinessJustification, BusinessReason, Category, ChangeRequestNumber, ChangeType, Description, Description_required_at_Customers_End__c,
                                               EstimatedEndTime, EstimatedStartTime, FinalReviewDateTime, FinalReviewNotes, Impact, Priority, RemediationPlan, RiskImpactAnalysis, RiskLevel, Status,
                                               StatusCode, Sub_Team__c, Subject, VLSF_Any_explicit_testing_required__c, VLSF_Backup_Plan__c, VLSF_Business_Approval_Required__c,
                                               VLSF_Change_Category__c, VLSF_Change_Schedule_end_Date_Time__c, VLSF_Change_Schedule_start_Date_Time__c, VLSF_Close_Summary__c, VLSF_Cost_associated_with_Change__c,
                                               VLSF_Customer_Change_Management_Required__c,VLSF_Change_Type__c, VLSF_Customers_Pre_notified_Major_change__c, VLSF_Date_Time_Closed__c, VLSF_Delivery_Testing_Required__c, VLSF_Impact_on_Business__c, VLSF_Impact_on_Performance__c,
                                               VLSF_Impact_on_Security__c, VLSF_Impacted_Environments__c, VLSF_Implementation_Plan__c, VLSF_Initiator__c, VLSF_Justification_For_The_Change__c, VLSF_Make_Jenkins_Callout__c, VLSF_Release_Cycle__c, VLSF_Risk__c,
                                               VLSF_Task_Team__c, VLSF_Team__c, VLSF_Third_party_Software_Tool_Involved__c, VLSF_User_Email_ID__c, VLSF_Initiator__r.Name  from ChangeRequest  WHERE Id IN :changeRequestIDs];
                
                for (ChangeRequest crData : crQuery) {
                    Map<String, Object> escalationBody = new Map<String, Object>();
                    escalationBody.put('Subject', crData.Subject);
                    escalationBody.put('Description', crData.Description);
                    escalationBody.put('Priority', crData.Priority);
                    escalationBody.put('Change_Category', crData.VLSF_Change_Category__c);
                    recordNumber = crData.ChangeRequestNumber;
                    
                    //payloadList.add(details);
                    
                    for(string str : valuesMap.keyset()){
                        details.put(str, crData.get(string.valueOf(valuesMap.get(str))));
                    }
                    system.debug('values...'+details);
                    escalationBody.put('details',details); 
                    
                    // Add details to payload list
                    payloadList.add(escalationBody);  
                }
            }
            
            // Serialize payload once
            String payloadJson = JSON.serialize(payloadList);
            System.debug('payloadJson...'+payloadJson); 
            
            // Perform the callout outside the loop
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpointUrl);
            req.setMethod('POST');
            req.setBody(payloadJson);
            // Set headers
            for (String key : headers.keySet()) {
                req.setHeader(key, headers.get(key));
            }
            // Perform the callout
            Http http = new Http();
            HttpResponse res = http.send(req);
            // Handle the response as needed
            if (res.getStatusCode() == 200) {
                // Success
                System.debug('CNS API callout successful');
                //Store Success Log
                VLSF_ExceptionLog.SuccessLog(res.getBody(),recordNumber);
                
            } else {
                // Handle error
                System.debug('CNS API callout failed with status code: ' + res.getStatusCode());
                System.debug('Response body: ' + res.getBody());
            } 
        }catch(Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
            //Call Exception Class
            VLSF_ExceptionLog.ExceptionLog(e);
        }
    }
    
    
    // Method to retrieve endpoint URL from custom metadata
    public static String getEndpointUrlFromMetadataCNS() {
        try {
            // Query custom metadata to retrieve endpoint URL
            VLSF_Custom_Metadata_for_CNS_Callout__mdt metadata = [SELECT VLSF_Endpoint_Api__c FROM VLSF_Custom_Metadata_for_CNS_Callout__mdt LIMIT 1];
            return metadata.VLSF_Endpoint_Api__c;
        } catch (Exception e) {
            System.debug('Error retrieving endpoint URL from custom metadata: ' + e.getMessage());
            return null;
        }
    }
    
    // Method to retrieve headers from custom metadata
    public static Map<String, String> getHeadersFromMetadataCNS() {
        Map<String, String> headers = new Map<String, String>();
        try {
            // Query custom metadata to retrieve headers
            List<VLSF_Custom_Metadata_for_CNS_Callout__mdt> metadataList = [SELECT VLSF_Header_Key__c, VLSF_Header_Value__c FROM VLSF_Custom_Metadata_for_CNS_Callout__mdt];
            for (VLSF_Custom_Metadata_for_CNS_Callout__mdt metadata : metadataList) {
                headers.put(metadata.VLSF_Header_Key__c, metadata.VLSF_Header_Value__c);
            }
        } catch (Exception e) {
            System.debug('Error retrieving headers from custom metadata: ' + e.getMessage());
        }
        return headers;
    }
}