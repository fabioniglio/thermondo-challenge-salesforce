public with sharing class NpsSurveyService {

    private INpsHttpSender sender;

    public NpsSurveyService() {
        this(new NpsHttpSender());
    }

    public NpsSurveyService(INpsHttpSender sender) {
        this.sender = sender;
    }

    public Boolean send(List<Order> orders) {
        List<NpsHttpSender.SurveyRequest> payload = new List<NpsHttpSender.SurveyRequest>();

        for (Order o : orders) {
            if (o.BillToContact != null && String.isNotBlank(o.BillToContact.Email)) {
                payload.add(new NpsHttpSender.SurveyRequest(
                    o.Id,
                    o.OrderNumber,
                    o.BillToContact.Email
                ));
            }
        }

        return sender.send(payload);
    }
}