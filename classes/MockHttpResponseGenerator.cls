@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://obscure-beach-73718.herokuapp.com/aadharid/523456789012', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"firstName": "Rajesh","lastName": "Kottu", "Address": "Santa Residency", "city": "Hyderabad","district": "Hyderabad","state": "Telanagana","pincode": "500018"}');
        res.setStatusCode(200);
        return res;
    }
}