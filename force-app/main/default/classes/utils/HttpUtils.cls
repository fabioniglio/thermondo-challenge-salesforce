public with sharing class HttpUtils {

    /**
     * Sends a JSON POST request using a Named Credential
     * @param namedCredential DeveloperName of Named Credential (e.g., 'NPS')
     * @param payload Object to be JSON serialized
     * @return HttpResponse from the callout
     */
    public static HttpResponse postJson(String namedCredential, Object payload) {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('callout:' + namedCredential);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(payload));

        Http http = new Http();
        return http.send(req);
    }

    /**
     * Sends a GET request using a Named Credential
     * @param namedCredential DeveloperName of Named Credential
     * @return HttpResponse from the callout
     */
    public static HttpResponse get(String namedCredential) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('callout:' + namedCredential);

        Http http = new Http();
        return http.send(req);
    }
}