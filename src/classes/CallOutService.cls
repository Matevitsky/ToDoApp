/**
 * Created by Sergey on 22.10.2020.
 */

public class CallOutService {

    private static final String todoTaskEndPoint = 'callout:SK_Todo2' + '/services/apexrest/TodoTaskService/';
    private static final String CONTENT_TYPE = 'Content-Type';
    private static final String APPLICATION_JSON = 'application/json';

    @Future(Callout=true)
    public static void doCallOut(String jsonTasks, String methodType) {
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setHeader(CONTENT_TYPE, APPLICATION_JSON);
        request.setMethod(methodType);
        request.setBody(jsonTasks);
        request.setEndpoint(todoTaskEndPoint);
        http.send(request).getBody();
    }
}


