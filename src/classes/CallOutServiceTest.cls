/**
 * Created by Sergey on 28.10.2020.
 */

@IsTest private class CallOutServiceTest {

    @IsTest static void shouldMakeCallout() {
        Test.setMock(HttpCalloutMock.class,new CallOutServiceMock());

        Test.startTest();
        CallOutService.doCallOut('', '');
        Integer callouts = Limits.getCallouts();
        Test.stopTest();
        System.assertEquals(1, callouts);
    }
}
