/**
 * Created by Sergey on 23.10.2020.
 */

public with sharing class CreateSubTasksHelper {


    public static void createSubTask(List<TodoTask__c> newTodoTasks) {
        List<Subtask__c> subTasksList = new List<Subtask__c>();

        for (TodoTask__c testTodoTask : newTodoTasks) {
            if (testTodoTask.Origin__c == 'Case') {
                Subtask__c newSubtask = new Subtask__c();
                newSubtask.Name = testTodoTask.Description__c;
                newSubtask.TodoTask__c = testTodoTask.Id;
                subTasksList.add(newSubtask);
            }
        }

        if (subTasksList.size() > 0) {
            insert subTasksList;
        }
    }
}
