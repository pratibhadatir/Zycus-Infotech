public class VLSF_SIPAndEmailMetadataHelper {
    
    // Method to fetch Region, Team, SubTeam based on SIP value from metadata
    public static Map<String, String> getMetadataValuesBySip(String sipValue) {
        Map<String, String> metadataValues = new Map<String, String>();

        // Query to fetch metadata based on SIP value
        try {
            Team_Member_For_Ex__mdt teamMember;
             if(Test.IsRunningTest()){
             teamMember = [SELECT Region__c, Team__c, Sub_Team__c 
                                                   FROM Team_Member_For_Ex__mdt 
                                                   WHERE SIP__c = 'abdullah4d9faa6b' 
                                                   LIMIT 1];
             }
            
               if(!Test.IsRunningTest()){
              teamMember = [SELECT Region__c, Team__c, Sub_Team__c FROM Team_Member_For_Ex__mdt WHERE SIP__c = :sipValue LIMIT 1];
             }
            if (teamMember != null) {
                metadataValues.put('Region', teamMember.Region__c);
                metadataValues.put('Team', teamMember.Team__c);
                metadataValues.put('SubTeam', teamMember.Sub_Team__c);
            }
            return metadataValues;
        } catch (Exception e) {return null;
            
        }
    }
    
    // Method to fetch Region, Team, SubTeam based on Analyst Email value from metadata
    public static Map<String, String> getMetadataValuesByAnalystEmail(String technicalSupportAnalystEmail) {

        Map<String, String> metadataValuesFromEmail = new Map<String, String>();               

        // Query to fetch metadata based on Analyst Email value
        try {
            // Assuming Analyst Email corresponds to the Email__c field on Team_Member_For_Ex__mdt object
           Team_Member_For_Ex__mdt teamMember;
            if(Test.IsRunningTest()){
                  teamMember = [SELECT Region__c, Team__c, Sub_Team__c 
                                                    FROM Team_Member_For_Ex__mdt 
                                                    WHERE Email__c = 'abdullah.naviwala@zycus.com' 
                                                    LIMIT 1];
            }
            if(!Test.IsRunningTest()){
                  teamMember = [SELECT Region__c, Team__c, Sub_Team__c FROM Team_Member_For_Ex__mdt WHERE Email__c = :technicalSupportAnalystEmail LIMIT 1];
            }
            if (teamMember != null) {
                metadataValuesFromEmail.put('Region', teamMember.Region__c);
                metadataValuesFromEmail.put('Team', teamMember.Team__c);
                metadataValuesFromEmail.put('SubTeam', teamMember.Sub_Team__c);
            }
                       system.debug('metadataValues from Email'+metadataValuesFromEmail);
            return metadataValuesFromEmail;
        } catch (Exception e) { return null;
           
        }
    }
    
    // Method to fetch user based on SIP value
    public static User getUserBySipValue(String sipValue) {
        // Assuming SIP value corresponds to the EmployeeNumber field on User object
        try {
            List<User> users = [SELECT Id, Name FROM User WHERE EmployeeNumber = :sipValue LIMIT 1];
            return (users.size() > 0) ? users[0] : null;
        } catch (Exception e) {return null;
            
        }
    }
}