@isTest
global class CibilMockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://obscure-beach-73718.herokuapp.com/CIBIL/SUPER00007', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"CIBIL" : "800"}');
        res.setStatusCode(200);
        return res;
    }
}