public with sharing class SendNpsSurveyAction {

    public class InputVariables {
        @InvocableVariable(required=true)
        public Id orderId;
    }

    public class OutputVariables {
        @InvocableVariable public Id orderId;
        @InvocableVariable public Boolean success;
        @InvocableVariable public String message;
    }

    @InvocableMethod(label='Send NPS Survey to Customer')
    public static List<OutputVariables> sendSurvey(List<InputVariables> inputs) {
        List<OutputVariables> outputs = new List<OutputVariables>();
        List<Id> orderIds = new List<Id>();

        for (InputVariables input : inputs) {
            if (input.orderId != null) {
                orderIds.add(input.orderId);
            }
        }

        List<Order> orders = OrderSelector.selectByIdsWithContact(orderIds);

        List<Order> filteredOrders = new List<Order>();
        for (Order o : orders) {
            if (!o.Survey_Sent__c) {
                filteredOrders.add(o);
            }
        }
        orders = filteredOrders;
        
        if (orders.isEmpty()) {
            for (InputVariables input : inputs) {
                OutputVariables output = new OutputVariables();
                output.orderId = input.orderId; 
                output.success = true;          
                output.message = 'Survey already sent or nothing to process';
                outputs.add(output);
            }
            return outputs;
        }

        try {
            Boolean sent = new NpsSurveyService().send(filteredOrders);

            List<Order> toUpdate = new List<Order>();

            for (Order o : orders) {
                OutputVariables output = new OutputVariables();
                output.orderId = o.Id;
                output.success = sent;
                output.message = sent ? 'Email sent successfully' : 'Failed to send email';
                outputs.add(output);

                if (sent) {
                    o.Survey_Sent__c = true;
                    toUpdate.add(o);
                }
            }

            if (!toUpdate.isEmpty()) {
                update toUpdate;
            }

            
        } catch (Exception ex) {
            for (Order o : orders) {
                OutputVariables output = new OutputVariables();
                output.orderId = o.Id;
                output.success = false;
                output.message = 'Error: ' + ex.getMessage();
                outputs.add(output);
            }
        }

        return outputs;
    }
}