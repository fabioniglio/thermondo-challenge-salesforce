public with sharing class OrderSelector {
    

    public static List<Order> selectByIdsWithContact(List<Id> orderIds) {
        if (orderIds == null || orderIds.isEmpty()) {
            return new List<Order>();
        }

        return [
            SELECT Id, OrderNumber, BillToContact.Email
            FROM Order
            WHERE Id IN :orderIds
        ];
    }

}