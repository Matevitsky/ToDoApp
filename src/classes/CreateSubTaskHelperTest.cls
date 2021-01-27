/**
 * Created by Sergey on 28.10.2020.
 */

@IsTest private class CreateSubTaskHelperTest {

    @TestSetup static void init() {
        Triggers.areDisabled = true;
        TodoTask__c task = new TodoTask__c(Name = 'test',Category__c ='Information',
            Description__c = 'Test Description', Origin__c = 'Case');
        insert task;

    }

    @IsTest static void shouldCreateSubTask() {
        List<TodoTask__c> todoTasks = [SELECT Id,Description__c,Origin__c FROM TodoTask__c];

        Test.startTest();
        CreateSubTasksHelper.createSubTask(todoTasks);
        Test.stopTest();
        List<Subtask__c> subtasks = [SELECT Id,Name,TodoTask__c FROM Subtask__c WHERE TodoTask__c IN :todoTasks];
        System.assertEquals(1,subtasks.size());
        for(Subtask__c subtask: subtasks){
            System.assertEquals('Test Description',subtask.Name);
        }
    }
}
