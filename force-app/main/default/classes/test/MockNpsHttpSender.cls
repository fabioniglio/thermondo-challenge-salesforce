public class MockNpsHttpSender implements INpsHttpSender {

    public Boolean shouldSucceed = true;
    public Integer callCount = 0;
    public List<NpsSurveyRequest> lastPayload;

    public Boolean send(List<NpsSurveyRequest> payload) {
        callCount++;
        lastPayload = payload;
        return shouldSucceed;
    }
}