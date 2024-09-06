global class VLSFOpsgenieResponseGenerator implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req){
        
        HttpResponse res = new HttpResponse();
        //Response For Status Update, Status Closed, Alert Created(Escalation)
      /*  if(req.getEndpoint()!='https://api.opsgenie.com/v2/alerts/requests/43a29c5c-3dbf-4fa4-9c26-f4f71023e121' && 
           req.getEndpoint() != 'https://api.opsgenie.com/v2/alerts/TestAlias?identifierType=alias'){

            System.debug('Endpoint..'+req.getEndpoint());
            //System.assertEquals('https://api.opsgenie.com/v2/alerts', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
        
            // Create a fake response            
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "result": "Request will be processed", "took": 0.302, "requestId": "43a29c5c-3dbf-4fa4-9c26-f4f71023e121"}');
            res.setStatusCode(202); 
        } */
        if(req.getEndpoint()== 'https://api.opsgenie.com/v1/json/integrations/webhooks/salesforceservicecloud?apiKey=d1de5d37-0540-4421-aaaa-ac1c5fed7dc4'){
            res.setHeader('Content-Type', 'application/json');           
            System.assertEquals('POST', req.getMethod());
            res.setBody('{ "result": "Request will be processed", "took": 0.302, "requestId": "43a29c5c-3dbf-4fa4-9c26-f4f71023e121"}');
            res.setStatusCode(202);
            
        }
        //return res;
        else if(req.getEndpoint()=='https://api.opsgenie.com/v2/alerts/requests/43a29c5c-3dbf-4fa4-9c26-f4f71023e121'){
        
            System.debug('Endpoint..'+req.getEndpoint());
            //System.assertEquals('https://api.opsgenie.com/v2/alerts', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
        
            // Create a fake response
            res.setHeader('Content-Type', 'application/json');
            // Construct a map representing the response body
            Map<String, Object> responseBodyMap = new Map<String, Object>();
            Map<String, Object> dataMap = new Map<String, Object>();
            dataMap.put('success', true);
            dataMap.put('action', 'Create');
            dataMap.put('processedAt', '2017-05-24T14:24:20.844Z');
            dataMap.put('integrationId', 'c9cec2cb-e782-4ebb-bc1d-1b2fa703cf03');
            dataMap.put('isSuccess', true);
            dataMap.put('alertId', '8743a1b2-11da-480e-8493-744660987beg');
            dataMap.put('alias', '8743a1b2-11da-480e-8493-744660987beg');
            responseBodyMap.put('data', dataMap);
            responseBodyMap.put('took', 0.022);
            responseBodyMap.put('requestId', 'ec7e1d8e-1c75-442e-a271-731070a7fa4d');
            // Serialize the map into a JSON string
            String resBody = JSON.serialize(responseBodyMap);
            // Set the response body
            res.setBody(resBody);
            res.setStatusCode(200);
        }  

        else if(req.getEndpoint() == 'https://api.opsgenie.com/v2/alerts/testAlias/acknowledge'){
            res.setHeader('Content-Type', 'application/json');           
            System.assertEquals('POST', req.getMethod());
            res.setBody('{ "result": "Request will be processed", "took": 0.302, "requestId": "43a29c5c-3dbf-4fa4-9c26-f4f71023e121"}');
            res.setStatusCode(202);
        } 
        else if(req.getEndpoint() == 'https://api.opsgenie.com/v2/alerts/TestAlertId/close?identifierType=id'){
            res.setHeader('Content-Type', 'application/json');           
            System.assertEquals('POST', req.getMethod());
            res.setBody('{ "result": "Request will be processed", "took": 0.302, "requestId": "43a29c5c-3dbf-4fa4-9c26-f4f71023e121"}');
            res.setStatusCode(202);
        }
        else if(req.getEndpoint() == 'https://api.opsgenie.com/v2/alerts'){
            res.setHeader('Content-Type', 'application/json');           
            System.assertEquals('POST', req.getMethod());
            res.setBody('{ "result": "Request will be processed", "took": 0.302, "requestId": "43a29c5c-3dbf-4fa4-9c26-f4f71023e121"}');
            res.setStatusCode(202);
        }

        return res;       
    } 
}