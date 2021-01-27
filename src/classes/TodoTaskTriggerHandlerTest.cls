/**
 * Created by MKA on 23.10.2020.
 */
@IsTest
public with sharing class TodoTaskTriggerHandlerTest {

    @IsTest public static void createCase() {
        Triggers.areDisabled = true;
        List<TodoTask__c> todoTasks = new List<TodoTask__c>();

        TodoTask__c newtTodoTask = new TodoTask__c();
        newtTodoTask.Origin__c = 'Case';
        newtTodoTask.Name = 'Test Subject';
        newtTodoTask.Category__c = 'Information';
        todoTasks.add(newtTodoTask);

        insert todoTasks;
    }


}
