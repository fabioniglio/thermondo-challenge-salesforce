public class MockNpsHttpSenderFailIfCalled implements INpsHttpSender {
    public Boolean send(List<NpsSurveyRequest> payload) {
        System.assert(false, 'send() should NOT be called for already-sent orders');
        return false;
    }
}