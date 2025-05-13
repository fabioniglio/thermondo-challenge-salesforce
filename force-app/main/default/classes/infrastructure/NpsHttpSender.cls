public with sharing class NpsHttpSender implements INpsHttpSender {


    public Boolean send(List<NpsSurveyRequest> payload) {
        Boolean allSuccessful = true;
        Integer batchSize = 30;
    
        for (Integer i = 0; i < payload.size(); i += batchSize) {
            List<NpsSurveyRequest> batch = new List<NpsSurveyRequest>();
    
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