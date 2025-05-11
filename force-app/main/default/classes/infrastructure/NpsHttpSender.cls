public with sharing class NpsHttpSender implements INpsHttpSender {

    public class SurveyRequest {
        public String sfId;
        public String orderNumber;
        public String customerEmail;

        public SurveyRequest(String sfId, String orderNumber, String customerEmail) {
            this.sfId = sfId;
            this.orderNumber = orderNumber;
            this.customerEmail = customerEmail;
        }
    }

    public Boolean send(List<SurveyRequest> payload) {
        Boolean allSuccessful = true;
        Integer batchSize = 30;

        for (Integer i = 0; i < payload.size(); i += batchSize) {
            List<SurveyRequest> batch = new List<SurveyRequest>();
            for (Integer j = i; j < Math.min(i + batchSize, payload.size()); j++) {
                batch.add(payload[j]);
            }

            if (!batch.isEmpty()) {
                HttpResponse res = HttpUtils.postJson('NPS', batch);
                if (res.getStatusCode() != 200) {
                    allSuccessful = false;
                }
            }
        }

        return allSuccessful;
    }
}