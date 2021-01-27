/**
 * Created by MKA on 17.10.2020.
 */
@IsTest
public class TodoTaskViewControllerTest {

    @TestSetup static void setup() {
        Triggers.areDisabled = true;
        List<TodoTask__c> testTodoTasks = new List<TodoTask__c>();
        for (Integer i = 0; i < 2; i++) {
            testTodoTasks.add(new TodoTask__c(Name = 'task', Category__c = 'Information'));
        }

        insert (List<SObject>) testTodoTasks;
    }
    @IsTest static void shouldReturnTaskByCategory() {
        Triggers.areDisabled = true;
        Test.startTest();
        List<TodoTask__c> tasks = TodoTaskViewController.getTodoTask('Information',true);
        for (TodoTask__c task : tasks) {
            System.assertEquals('Information', task.Category__c);
            System.assertEquals('true', task.Category__c);
        }
        Test.stopTest();
    }

    @IsTest static void shouldReturnSaveTodoTask() {
        Test.startTest();
        List<TodoTask__c> todoList = TodoTaskViewController.getTodoTask('', true);
        Test.stopTest();

        System.assertNotEquals(null, todoList);
    }

    @IsTest static void shouldReturnCompleteTask() {
        Triggers.areDisabled = true;
        Test.startTest();
        List<TodoTask__c> tasks = [SELECT Id, IsComplete__c FROM TodoTask__c];
        for (TodoTask__c task : tasks) {
            TodoTask__c completedTask = TodoTaskViewController.completeTask(task.Id);
            System.assertEquals(true, completedTask.IsComplete__c);
        }
        Test.stopTest();
    }

    @IsTest static void shouldDeleteTask() {
        Triggers.areDisabled = true;
        Test.startTest();
        List<TodoTask__c> tasks = [SELECT Id, IsComplete__c FROM TodoTask__c];
        for (TodoTask__c task : tasks) {
            Boolean result = TodoTaskViewController.deleteTodoTask(task.Id);
            System.assert(result);
        }
        Test.stopTest();
    }

    @IsTest static void shouldReturnFalseWhenDeleteTask() {
        Triggers.areDisabled = true;
        Test.startTest();
        Boolean result;
        try {
            result = TodoTaskViewController.deleteTodoTask('1');
        } catch (Exception e) {
            result = false;
        }
        System.assert(!result);
        Test.stopTest();
    }
}
