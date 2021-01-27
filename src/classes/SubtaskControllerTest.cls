/**
 * Created by Sergey on 28.10.2020.
 */

@IsTest private class SubtaskControllerTest {

    @TestSetup static void init() {
        Triggers.areDisabled = true;
        TodoTask__c task = new TodoTask__c(Category__c = 'Information');
        insert task;
        Subtask__c subtask = new Subtask__c(Name = 'subtask', TodoTask__c = task.Id);
        insert subtask;
    }

    @IsTest static void shouldReturnSubTasksByTaskId() {

        Test.startTest();

        List<TodoTask__c> tasks = [SELECT Id,Category__c FROM TodoTask__c];
        for (TodoTask__c task : tasks) {
            List<Subtask__c> subtasks = SubtaskController.getSubtasks(task.Id);
            System.assertEquals(1, subtasks.size());
        }
        Test.stopTest();
    }

    @IsTest static void shouldInsertSubTask() {

        Test.startTest();

        List<TodoTask__c> tasks = [SELECT Id,Category__c FROM TodoTask__c];
        System.debug(tasks.size());
        Subtask__c subtask = SubtaskController.insertSubtask('test subtask', tasks.get(0).Id);

        Test.stopTest();

        System.assertNotEquals(null, subtask);
    }
    @IsTest static void shouldReturnNull() {

        Test.startTest();
        Subtask__c subtask;
        try {
            subtask = SubtaskController.insertSubtask('test subtask', '123');
        } catch (Exception e) {
            System.assert(subtask == null);
        }

        Test.stopTest();


    }

    @IsTest static void shouldDeleteSubTask() {

        Test.startTest();

        List<TodoTask__c> tasks = [SELECT Id,Category__c FROM TodoTask__c];
        Subtask__c subtask = [SELECT Id FROM Subtask__c WHERE TodoTask__c = :tasks.get(0).Id];
        SubtaskController.deleteSubtask(subtask.Id);
        List<Subtask__c> subtasks = [SELECT Id FROM Subtask__c WHERE TodoTask__c = :tasks.get(0).Id];

        Test.stopTest();

        System.assertEquals(0, subtasks.size());
    }

    @IsTest static void shouldReturnFalse() {

        Test.startTest();
        Boolean result;
        try {
            result = SubtaskController.deleteSubtask( '123');
        } catch (Exception e) {
            System.assert(result == null);
        }

        Test.stopTest();


    }
}
