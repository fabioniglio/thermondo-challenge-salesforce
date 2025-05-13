public class FailingNpsHttpSender implements INpsHttpSender {
    public Boolean send(List<NpsSurveyRequest> payload) {
        throw new System.CalloutException('Simulated HTTP error');
    }
}