/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest
private class NpsSurveyServiceTest {

    @IsTest
    static void testSendSurvey_successfulCallout() {
        MockNpsHttpSender mockSender = new MockNpsHttpSender();
        mockSender.shouldSucceed = true;

        Order testOrder = new Order();
        testOrder.Id = '801000000000001';
        testOrder.BillToContact = new Contact(Email = 'test@example.com');
        List<Order> fakeOrders = new List<Order>{ testOrder };

        NpsSurveyService service = new NpsSurveyService(mockSender);
        Boolean result = service.send(fakeOrders);

        System.assertEquals(true, result, 'Survey send should succeed');
        System.assertEquals(1, mockSender.callCount, 'send() should have been called once');
        System.assertEquals(1, mockSender.lastPayload.size(), 'Payload should contain one survey request');
        System.assertEquals(testOrder.Id, mockSender.lastPayload[0].sfId);
    }

    @IsTest
    static void testSendSurvey_failedCallout() {
        MockNpsHttpSender mockSender = new MockNpsHttpSender();
        mockSender.shouldSucceed = false;

        Order testOrder = new Order();
        testOrder.Id = '801000000000002';
        testOrder.BillToContact = new Contact(Email = 'fail@example.com');
        List<Order> fakeOrders = new List<Order>{ testOrder };

        NpsSurveyService service = new NpsSurveyService(mockSender);
        Boolean result = service.send(fakeOrders);

        System.assertEquals(false, result, 'Survey send should fail');
        System.assertEquals(1, mockSender.callCount, 'send() should have been called once');
    }

    @IsTest
    static void testSendSurvey_noOrders() {
        MockNpsHttpSender mockSender = new MockNpsHttpSender();
        List<Order> emptyOrders = new List<Order>();

        NpsSurveyService service = new NpsSurveyService(mockSender);
        Boolean result = service.send(emptyOrders);

        System.assertEquals(true, result, 'Empty input should be treated as success');
        System.assertEquals(0, mockSender.callCount, 'send() should not be called for empty input');
    }
}