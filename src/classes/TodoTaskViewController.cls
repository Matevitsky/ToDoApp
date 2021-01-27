/**
 * Created by MKA on 18.10.2020.
 */

public class TodoTaskViewController {


    @AuraEnabled
    (Cacheable=true)
    public static List<TodoTask__c> getTodoTask(String category, Boolean isCompleted) {

        System.debug('Categoru is '+'*'+category+' *'+' iscomplete'+isCompleted);
        if (category == '') {
            System.debug('Enter to getAll tasks');
            return getAllTodoTasks(isCompleted);
        } else {
            System.debug('Enter to getToDoTasksByCategory tasks');
            return getToDoTasksByCategory(category, isCompleted);
        }
    }


    private static List<TodoTask__c> getAllTodoTasks(Boolean isCompleted) {
        return [
            SELECT Id, Name, Category__c, (SELECT Name FROM Subtasks__r)
            FROM TodoTask__c
            WHERE IsComplete__c = :isCompleted
        ];
    }

    private static List<TodoTask__c> getToDoTasksByCategory(String category, Boolean isCompleted) {
        return [
            SELECT Id, Name,Category__c, (SELECT Name FROM Subtasks__r)
            FROM TodoTask__c
            WHERE Category__c = :category AND IsComplete__c = :isCompleted
        ];
    }

    @AuraEnabled
    public static Boolean deleteTodoTask(Id recordId) {
        try {
            Database.delete(recordId);
            return true;
        } catch (Exception e) {
            return false;
        }

    }

    @AuraEnabled
    public static TodoTask__c completeTask(String taskId) {
        TodoTask__c task = [
            SELECT Id, IsComplete__c
            FROM TodoTask__c
            WHERE Id = :taskId
        ];
        task.IsComplete__c = true;
        update task;
        return task;
    }
}
