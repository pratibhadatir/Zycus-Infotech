public class VLSF_JiraMockHttpResponse implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"key":"TEST-123","fields":{"summary":"Test issue"}}'); // Mock JIRA response
        res.setStatusCode(200);
        return res;
    }
    
}