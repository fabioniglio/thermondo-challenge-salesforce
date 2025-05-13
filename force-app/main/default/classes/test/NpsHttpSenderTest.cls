@IsTest
private class NpsHttpSenderTest {

    private class MockHttpSenderSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"success":true}');
            return res;
        }
    }

    private class MockHttpSenderFail implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            res.setBody('{"error":"Server error"}');
            return res;
        }
    }

    @IsTest
    static void testSendSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpSenderSuccess());

        List<NpsSurveyRequest> payload = new List<NpsSurveyRequest>{
            new NpsSurveyRequest('001000000000001', 'ORD-001', 'test@example.com')
        };

        Test.startTest();
        Boolean result = new NpsHttpSender().send(payload);
        Test.stopTest();

        System.assertEquals(true, result, 'Should return true when API responds with 200');
    }

    @IsTest
    static void testSendFailure() {
        Test.setMock(HttpCalloutMock.class, new MockHttpSenderFail());

        List<NpsSurveyRequest> payload = new List<NpsSurveyRequest>{
            new NpsSurveyRequest('001000000000001', 'ORD-001', 'fail@example.com')
        };

        Test.startTest();
        Boolean result = new NpsHttpSender().send(payload);
        Test.stopTest();

        System.assertEquals(false, result, 'Should return false when API responds with error');
    }

    @IsTest
    static void testSendEmptyPayload() {
        Test.startTest();
        Boolean result = new NpsHttpSender().send(new List<NpsSurveyRequest>());
        Test.stopTest();

        System.assertEquals(true, result, 'Empty payload should be treated as success (no-op)');
    }
}