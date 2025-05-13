public with sharing class OrderSelector extends fflib_SObjectSelector {

    public static List<Order> selectByIdsWithContact(List<Id> orderIds) {
        return [
            SELECT Id, OrderNumber, Survey_Sent__c, BillToContact.Email
            FROM Order
            WHERE Id IN :orderIds
        ];
    }

    public Schema.SObjectType getSObjectType() {
        return Order.SObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Order.Id,
            Order.OrderNumber,
            Order.Survey_Sent__c,
            Order.BillToContactId 
        };
    }
}