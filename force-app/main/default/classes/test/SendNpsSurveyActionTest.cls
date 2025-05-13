@IsTest
private class SendNpsSurveyActionTest {

    @testSetup
    static void setupTestData() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact contact = new Contact(LastName = 'Test User', Email = 'test@example.com');
        insert contact;

        Id standardPbId = Test.getStandardPricebookId();
        Pricebook2 stdPb = new Pricebook2(Id = standardPbId, IsActive = true);
        update stdPb;

        Product2 product = new Product2(Name = 'Test Product', IsActive = true);
        insert product;

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = stdPb.Id,
            Product2Id = product.Id,
            UnitPrice = 10,
            IsActive = true
        );
        insert pbe;

        Order order = new Order(
            AccountId = acc.Id,
            BillToContactId = contact.Id,
            Pricebook2Id = stdPb.Id,
            Status = 'Draft',
            EffectiveDate = Date.today()
        );
        insert order;

        OrderItem item = new OrderItem(
            OrderId = order.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 1,
            UnitPrice = 10
        );
        insert item;

    }

    @IsTest
    static void testInvocable_sendSuccessful() {
        
        Order order = [SELECT Id FROM Order LIMIT 1];

        MockNpsHttpSender mock = new MockNpsHttpSender();
        mock.shouldSucceed = true;
        NpsSurveyService.TEST_OVERRIDE = mock;

        SendNpsSurveyAction.InputVariables input = new SendNpsSurveyAction.InputVariables();
        input.orderId = order.Id;

        List<SendNpsSurveyAction.InputVariables> inputs = new List<SendNpsSurveyAction.InputVariables>{ input };

        Test.startTest();
        List<SendNpsSurveyAction.OutputVariables> result = SendNpsSurveyAction.sendSurvey(inputs);
        Test.stopTest();


        System.assertEquals(1, result.size(), 'Should return one result');
        System.assertEquals(order.Id, result[0].orderId);
        System.assertEquals(true, result[0].success, 'Survey should succeed');
        System.assert(result[0].message != null);

        NpsSurveyService.TEST_OVERRIDE = null;
    }

    @IsTest
    static void testInvocable_sendError() {
    
        
        Order order = [SELECT Id FROM Order LIMIT 1];

        NpsSurveyService.TEST_OVERRIDE = new FailingNpsHttpSender();

        SendNpsSurveyAction.InputVariables input = new SendNpsSurveyAction.InputVariables();
        input.orderId = order.Id;

        List<SendNpsSurveyAction.InputVariables> inputs = new List<SendNpsSurveyAction.InputVariables>{ input };

        
        Test.startTest();
        List<SendNpsSurveyAction.OutputVariables> results = SendNpsSurveyAction.sendSurvey(inputs);
        Test.stopTest();

        
        System.assertEquals(1, results.size(), 'Should return one result');
        System.assertEquals(order.Id, results[0].orderId);
        System.assertNotEquals(true, results[0].success, 'Expected failure due to exception');
        System.assert(results[0].message != null && results[0].message.contains('Simulated'), 'Error message should contain exception text');

        
        NpsSurveyService.TEST_OVERRIDE = null;
    }
}