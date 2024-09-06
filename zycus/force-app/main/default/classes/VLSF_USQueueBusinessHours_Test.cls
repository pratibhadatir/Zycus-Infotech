@isTest
public class VLSF_USQueueBusinessHours_Test { 
    @isTest
    public static void isWithinBusinessHoursTest(){
        Datetime testDateTime = Datetime.newInstance(2024, 4, 20, 10, 0, 0);
        VLSF_USQueueBusinessHours.isWithinBusinessHours(testDateTime);
    }  
    @isTest
    public static void isWorkingHours(){
        Datetime testDateTime = Datetime.newInstance(2024, 4, 20, 10, 0, 0);
        List<Datetime> dateTimeList = new List<Datetime>();
        dateTimeList.add(testDateTime);
        VLSF_USQueueBusinessHours.isWorkingHours(dateTimeList);
    }
    
}