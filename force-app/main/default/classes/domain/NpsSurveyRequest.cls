public class NpsSurveyRequest {
    public String sfId;
    public String orderNumber;
    public String customerEmail;

    public NpsSurveyRequest(String sfId, String orderNumber, String customerEmail) {
        this.sfId = sfId;
        this.orderNumber = orderNumber;
        this.customerEmail = customerEmail;
    }
}