@IsTest
private class HttpUtilsTest {

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"success": true}');
            res.setStatusCode(200);
            return res;
        }
    }

    @IsTest
    static void testPostJson() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Example payload
        Map<String, String> payload = new Map<String, String>{
            'key' => 'value'
        };

        Test.startTest();
        HttpResponse response = HttpUtils.postJson('NPS', payload);
        Test.stopTest();

        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('{"success": true}', response.getBody());
    }

    @IsTest
    static void testGet() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        HttpResponse response = HttpUtils.get('NPS');
        Test.stopTest();

        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('{"success": true}', response.getBody());
    }
}