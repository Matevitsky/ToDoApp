/**
 * Created by MKA on 17.10.2020.
 */
@IsTest
private  class TodoTaskControllerTest {

    @IsTest static void shouldCreateTodoTask() {
        Triggers.areDisabled = true;
        TodoTask__c todoTask = new TodoTask__c();
        todoTask.Name = 'subject';
        todoTask.Category__c = 'Information';
        TodoTask__c expected = new TodoTask__c();

        System.Test.startTest();
        expected = ToDoTaskController.createToDoTask(todoTask);
        System.Test.stopTest();

        System.assertNotEquals(null, expected.Id);

    }

}
