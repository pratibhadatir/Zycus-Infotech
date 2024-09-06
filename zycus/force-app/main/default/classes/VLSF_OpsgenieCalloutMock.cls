public class VLSF_OpsgenieCalloutMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"result":"success"}');
        res.setStatusCode(202);
        return res;
    }
}