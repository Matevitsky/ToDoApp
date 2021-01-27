/**
 * Created by Serhii on 22.10.2020.
 */

@IsTest
public with sharing class CaseTriggerHandlerTest {

    @IsTest static void createCase() {
        Triggers.areDisabled = true;
        List<Case> casesList = new List<Case>();
        Case newCase = new Case();
        newCase.Origin = 'Email';
        newCase.Subject = 'Test Subject';
        newCase.Status = 'New';
        casesList.add(newCase);

        List<TodoTask__c> todoTasks = new List<TodoTask__c>();

        Test.startTest();
        CaseTriggerHandler handler = new CaseTriggerHandler();
        handler.beforeInsert(casesList);
        todoTasks = [SELECT Id,Name,Category__c FROM TodoTask__c];
        Test.stopTest();

        System.assertEquals(1, todoTasks.size());
        for (TodoTask__c task : todoTasks) {
            System.assertEquals('Test Subject', task.Name);
            System.assertEquals('Information', task.Category__c);
        }

    }
}
