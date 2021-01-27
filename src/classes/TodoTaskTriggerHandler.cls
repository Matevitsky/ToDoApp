/**
 * Created by MKA on 23.10.2020.
 */

public class TodoTaskTriggerHandler {

    public static void afterInsert(List<TodoTask__c> newTodoTasks) {
        CreateSubTasksHelper.createSubTask(newTodoTasks);
        TodoTaskRestHelper.insertTask(newTodoTasks);
    }
    public static void afterUpdate(List<TodoTask__c> updatedTasks) {
        TodoTaskRestHelper.updateTask(updatedTasks);
    }
    public static void beforeDelete(List<TodoTask__c> tasksToDelete) {
        TodoTaskRestHelper.deleteTask(tasksToDelete);
    }
}
