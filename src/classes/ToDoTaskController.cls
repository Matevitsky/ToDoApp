/**
 * Created by MKA on 17.10.2020.
 */

public class ToDoTaskController {

    @AuraEnabled
    public static TodoTask__c createToDoTask(TodoTask__c todoTask) {
        insert todoTask;
        return todoTask;
    }
}
