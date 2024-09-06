Global class VLSFCNS_JenkinsResponse implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
         System.debug('Endpoint..'+req.getEndpoint());
         //System.assertEquals('https://api.opsgenie.com/v2/alerts', req.getEndpoint());
         System.assertEquals('POST', req.getMethod());
        
         // Create a fake response            
         res.setHeader('Content-Type', 'application/json');
         res.setBody('{"statusCode": 200,"body": "\"Hello from Lambda!\""}');
         res.setStatusCode(200); 
        
        return res;
    }

}