public with sharing class NpsSurveyService {

    public static INpsHttpSender TEST_OVERRIDE;

    private INpsHttpSender sender;

    public NpsSurveyService() {
        this(TEST_OVERRIDE != null ? TEST_OVERRIDE : new NpsHttpSender());
    }

    public NpsSurveyService(INpsHttpSender sender) {
        this.sender = sender;
    }

    public Boolean send(List<Order> orders) {
        if (orders == null || orders.isEmpty()) return true;

        List<NpsSurveyRequest> payload = new List<NpsSurveyRequest>();
        for (Order o : orders) {
            if (o.BillToContact != null && String.isNotBlank(o.BillToContact.Email)) {
                payload.add(new NpsSurveyRequest(o.Id, o.OrderNumber, o.BillToContact.Email));
            }
        }

        if (payload.isEmpty()) return true;

        return sender.send(payload);
    }
}