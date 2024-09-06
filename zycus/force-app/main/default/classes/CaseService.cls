@RestResource(urlMapping='/caseService/*')
global with sharing class CaseService {
    
    // RESTful web service method to create a case
    @HttpPost
    global static String createCase(String subject, String description, String contactEmail) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            // Create a new Case object
            Case newCase = new Case();
            newCase.Subject = subject;
            newCase.Description = description;
            newCase.Origin = 'Web';
            
            // Insert the Case
            insert newCase;
            
            // Return the ID of the newly created case
            return newCase.Id;
        } catch (Exception e) {
            // Set the response status code to 400 and return the exception message in case of failure
            res.statusCode = 400;
            return 'Error: ' + e.getMessage();
        }
    }
    
}