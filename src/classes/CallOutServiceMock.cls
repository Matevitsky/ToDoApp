/**
 * Created by Sergey on 28.10.2020.
 */

@IsTest
global with sharing class CallOutServiceMock implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest request) {

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        return response;
    }
}
