public class VLSF_CheckBussinesHours{
    @InvocableMethod
    public static List<Boolean> checkBussinessHoursOfCase(List<String> inputTimeZoneId){
        List<String> parts = new List<string>();
        List<Boolean> outcome = new List<Boolean>();
        For (String tr : inputTimeZoneId){
            parts = tr.split(';');
        }

        // Extract the date-time string
        String dateTimeString = parts[1];
        Id businessId = parts[0];
        System.debug('dateTimeString::' + dateTimeString);
        System.debug('businessId::' + businessId);

        // Convert the datetime string to a DateTime object
        DateTime dt = DateTime.valueOf(dateTimeString);
        System.debug('dt::' + dt);

        // Assume dt is your DateTime variable
        //DateTime dt = DateTime.valueOf('2024-02-15 11:34:08');

        // Get the day of the week (Sunday = 1, Monday = 2, ..., Saturday = 7)
        String dayOfWeek = dt.format('EEEE');
        System.debug('businessId::' + businessId);

        // Get the time component
        Time timeOfDay = dt.time();
        System.debug('timeOfDay::' + timeOfDay);

        // Query the BusinessHours object for the desired day's start and end times
        BusinessHours bh = [SELECT SundayStartTime, SundayEndTime, MondayStartTime, MondayEndTime, TuesdayStartTime, TuesdayEndTime, WednesdayStartTime, WednesdayEndTime, ThursdayStartTime, ThursdayEndTime, FridayStartTime, FridayEndTime, SaturdayStartTime, SaturdayEndTime
                            FROM BusinessHours
                            Where id = :businessId];

        // Compare the time with the start and end times for the corresponding day
        Time startTime;
        Time endTime;

        switch  on dayOfWeek{
            when 'Sunday'{
                startTime = bh.SundayStartTime;
                endTime = bh.SundayEndTime;
            }
            when 'Monday'{
                startTime = bh.MondayStartTime;
                endTime = bh.MondayEndTime;
            }
            when 'Tuesday'{
                startTime = bh.TuesdayStartTime;
                endTime = bh.TuesdayEndTime;
            }
            when 'Wednesday'{ startTime = bh.WednesdayStartTime; endTime = bh.WednesdayEndTime;
            }
            when 'Thursday'{
                startTime = bh.ThursdayStartTime;
                endTime = bh.ThursdayEndTime;
            }
            when 'Friday'{
                startTime = bh.FridayStartTime;
                endTime = bh.FridayEndTime;
            }
            when 'Saturday'{
                startTime = bh.SaturdayStartTime;
                endTime = bh.SaturdayEndTime;
            }
            when else{
                // Handle invalid dayOfWeek value
                startTime = null; endTime = null;
            }
        }
        System.debug('startTime::' + startTime);
        System.debug('endTime::' + endTime);

        Time midnight = Time.newInstance(0, 0, 0, 0);
        if (startTime == midnight && endTime == midnight){
            // Shift spans across 24 hours
            System.debug('Shift spans across 24 hours.');
            outcome.add(true);
            return outcome;
        } else if (startTime <= endTime){
            // Regular business hours within a day
            if (timeOfDay >= startTime && timeOfDay <= endTime){
                System.debug('Time falls within business hours.');
                outcome.add(true); return outcome;
            } else{
                System.debug('Time falls outside business hours.');
                outcome.add(false); return outcome;
            }
        } else{
            // Business hours span across two days
            if (timeOfDay >= startTime || timeOfDay <= endTime){
                System.debug('Time falls within business hours.');
                outcome.add(true);return outcome;
            } else{
                System.debug('Time falls outside business hours.');
                outcome.add(false);return outcome;
            }
        }


        // Perform comparison
        /*if (timeOfDay >= startTime && timeOfDay <= endTime) {
         // Time falls within business hours for the given day
         System.debug('Time falls within business hours.');
         outcome.add(true);
         return outcome;
         } else {
         // Time falls outside business hours for the given day
         System.debug('Time falls outside business hours.');
         outcome.add(false);
         return outcome;
         }*/
    }

}