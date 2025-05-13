
@IsTest
private class OrderSelectorTest {

    @IsTest
    static void testSelectorMethods() {
        OrderSelector selector = new OrderSelector();

        System.assertEquals(Order.SObjectType, selector.getSObjectType(), 
            'getSObjectType should return Order SObjectType');

        List<Schema.SObjectField> fields = selector.getSObjectFieldList();
        System.assert(fields != null && fields.size() > 0, 
            'getSObjectFieldList should return non-empty field list');
    }
}
