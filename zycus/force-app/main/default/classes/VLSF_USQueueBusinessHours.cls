public class VLSF_USQueueBusinessHours {

    // Method to get the custom business hours ID
    public static Id getUSQueueBusinessHoursId() {
        // Replace 'US Queue Hours' with your actual business hours name
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE Name = 'US' LIMIT 1];
        return bh.Id;
    }

    // Method to check if a given date is within business hours
    public static list<Boolean> isWithinBusinessHours(Datetime targetDate) {
        Id businessHoursId = getUSQueueBusinessHoursId();
        List<Boolean> isOffList = new List<Boolean>();
        Boolean result = BusinessHours.isWithin(businessHoursId, targetDate);
        System.debug('Is within business hours? ' + result); // Debug statement
        isOffList.add(result);
        return isOffList;
    }

    // Method to exclude Saturdays from 9:00 AM to 11:00 AM
    @InvocableMethod
    public static list<Boolean> isWorkingHours(List<Datetime> targetDate) {
        list<Boolean> isOffList = new list<Boolean>();
        System.debug('Date Time:::'+targetDate[0]);
        System.debug('Date Time format:::'+targetDate[0].format('E', 'Asia/Kolkata'));
        if (targetDate[0].format('E', 'Asia/Kolkata') == 'Sat') {
            system.debug('New Date :'+ targetDate[0]);
            Integer hour = Integer.valueOf(targetDate[0].format('H', 'Asia/Kolkata'));
            System.debug('hour:::'+hour);
            Boolean isOff = (hour >= 9 && hour < 11);
            System.debug('Is Saturday off hours? ' + isOff); // Debug statement
            if(isOff){
               isOffList.add(False); 
            }else{
                isOffList.add(True); 
            }
            //isOffList.add(isOff);
            System.debug('Is Saturday off hours List? ' + isOffList); // Debug statement
            return isOffList;
        }
        return isWithinBusinessHours(targetDate[0]);
    }
    // Example usage
   
   /* public static void main() {
        // Get the current date and time
        Datetime currentDateTime = Datetime.now();
        List<DateTime> newDateTime = new List<DateTime>();
        // Check if it's working hours
        // 
        list<Boolean> result = isWorkingHours(newDateTime);

        System.debug('Is it working hours? ' + result);
    }*/
}