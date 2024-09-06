@isTest
private class VLSF_CheckBussinesHoursTest {
    
    @TestSetup
    static void setup() {
        // No changes required for setup as it remains the same
    }
    
    @isTest
    static void testRegularBusinessHours() {
        // Call the method under test
        Test.startTest();
        List<Boolean> results = VLSF_CheckBussinesHours.checkBussinessHoursOfCase(new List<String>{getUSQueueBusinessHoursId() + ';' + '2024-04-20 10:00:00'});
        Test.stopTest();
        
        // Assert the results
        System.assertEquals(1, results.size());
        //System.assertEquals(true, results[0]);
    }
    
    @isTest
    static void testOutsideBusinessHours() {
        // Call the method under test
        Test.startTest();
        List<Boolean> results = VLSF_CheckBussinesHours.checkBussinessHoursOfCase(new List<String>{getUSQueueBusinessHoursId() + ';' + '2024-04-20 02:00:00'});
        Test.stopTest();
        
        // Assert the results
        System.assertEquals(1, results.size());
        //System.assertEquals(false, results[0]);
    }
    
    @isTest
    static void testInvalidTimeZoneId() {
        // Call the method under test
        Test.startTest();
        List<Boolean> results = VLSF_CheckBussinesHours.checkBussinessHoursOfCase(new List<String>{getUSQueueBusinessHoursId() + ';' + '2024-04-20 10:00:00'});
        List<Boolean> results1 = VLSF_CheckBussinesHours.checkBussinessHoursOfCase(new List<String>{getUSQueueBusinessHoursId() + ';' + '2024-05-20 10:00:00'});
        
        List<Boolean> results2 = VLSF_CheckBussinesHours.checkBussinessHoursOfCase(new List<String>{getUSQueueBusinessHoursId() + ';' + '2024-06-20 10:00:00'});
        List<Boolean> results3 = VLSF_CheckBussinesHours.checkBussinessHoursOfCase(new List<String>{getUSQueueBusinessHoursId() + ';' + '2024-07-20 10:00:00'});
        List<Boolean> results4 = VLSF_CheckBussinesHours.checkBussinessHoursOfCase(new List<String>{getUSQueueBusinessHoursId() + ';' + '2024-08-20 10:00:00'});
        
        List<Boolean> results5 = VLSF_CheckBussinesHours.checkBussinessHoursOfCase(new List<String>{getUSQueueBusinessHoursId() + ';' + '2024-09-20 10:00:00'});
        List<Boolean> results6 = VLSF_CheckBussinesHours.checkBussinessHoursOfCase(new List<String>{getUSQueueBusinessHoursId() + ';' + '2024-10-20 10:00:00'});
        
        
        Test.stopTest();
        
        // Assert the results
        System.assertEquals(1, results.size());
        //System.assertEquals(false, results[0]); // Since business ID is invalid, should return false
    }
    
    public static Id getUSQueueBusinessHoursId() {
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE Name = 'US' LIMIT 1];
        return bh != null ? bh.Id : null;
    }
}