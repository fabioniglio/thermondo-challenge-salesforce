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
        // Arrange
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        INpsHttpSender mockSender = (INpsHttpSender) mocks.mock(INpsHttpSender.class);

        Order testOrder = new Order();
        testOrder.Id = '801000000000001';
        testOrder.BillToContact = new Contact(Email = 'test@example.com');
        List<Order> fakeOrders = new List<Order>{ testOrder };

        // Proper chaining of when().thenReturn()
        ((fflib_MethodReturnValue) mocks
            .when(mockSender, 'send')
            .withArguments((List<NpsSurveyRequest>) fflib_Match.anyList()))
            .thenReturn(true);


        // Act
        NpsSurveyService service = new NpsSurveyService(mockSender);
        Boolean result = service.send(fakeOrders);

        // Assert
        System.assertEquals(true, result, 'Survey send should succeed');

        // Verify
        ((INpsHttpSender) mocks.verify(mockSender, 1))
            .send((List<NpsHttpSender.SurveyRequest>)fflib_Match.anyList());
    }

    @IsTest
    static void testSendSurvey_failedCallout() {
        // Arrange
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        INpsHttpSender mockSender = (INpsHttpSender) mocks.mock(INpsHttpSender.class);

        Order testOrder = new Order();
        testOrder.Id = '801000000000002';
        testOrder.BillToContact = new Contact(Email = 'fail@example.com');
        List<Order> fakeOrders = new List<Order>{ testOrder };

        ((fflib_MethodReturnValue) mocks
        .when(mockSender, 'send')
        .withArguments((List<NpsSurveyRequest>) fflib_Match.anyList()))
        .thenReturn(true);


        // Act
        NpsSurveyService service = new NpsSurveyService(mockSender);
        Boolean result = service.send(fakeOrders);

        // Assert
        System.assertEquals(false, result, 'Survey send should fail gracefully');

        ((INpsHttpSender) mocks.verify(mockSender, 1))
            .send((List<NpsHttpSender.SurveyRequest>)fflib_Match.anyList());
    }

    @IsTest
    static void testSendSurvey_noOrders() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        INpsHttpSender mockSender = (INpsHttpSender) mocks.mock(INpsHttpSender.class);
        List<Order> emptyList = new List<Order>();

        NpsSurveyService service = new NpsSurveyService(mockSender);
        Boolean result = service.send(emptyList);

        System.assertEquals(true, result, 'Empty input should be treated as success');

        ((INpsHttpSender) mocks.verify(mockSender, 0))
            .send((List<NpsHttpSender.SurveyRequest>)fflib_Match.anyList());
    }
}
