/**
 * Created by Sergey on 24.10.2020.
 */

public with sharing class TodoTaskRestHelper {

    private static final String POST = 'POST';
    private static final String PUT = 'PUT';
    private static final String REMOVE = 'DELETE';

    public static void insertTask(List<TodoTask__c> newTasks) {
        String jsonTaskList = convertToJson(newTasks);
        CallOutService.doCallOut(jsonTaskList, POST);
    }

    private static String convertToJson(List<TodoTask__c> newTasks) {
        Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>([SELECT Id,Name FROM RecordType]);
        List<JsonWrapper> jsonTaskList = mpToJsonWrapper(newTasks, recordTypeMap);
        return JSON.serialize(jsonTaskList);
    }

     private static List<JsonWrapper> mpToJsonWrapper(List<TodoTask__c> newTasks, Map<Id, RecordType> recordTypeMap) {
        List<JsonWrapper> jsonTaskList = new List<JsonWrapper>();
        for (TodoTask__c task : newTasks) {
            JsonWrapper jsonWrapper = new JsonWrapper();
            jsonWrapper.category= task.Category__c;
            jsonWrapper.externalId = task.Id;
            jsonWrapper.subject = task.Name;
            jsonWrapper.origin = task.Origin__c;
            jsonWrapper.isComplete = task.IsComplete__c;
            jsonWrapper.recordTypeName = recordTypeMap.get(task.RecordTypeId).Name;
            jsonTaskList.add(jsonWrapper);
        }
        return jsonTaskList;
    }


    public static void updateTask(List<TodoTask__c> newTasks) {
        String jsonTaskList = convertToJson(newTasks);
        CallOutService.doCallOut(jsonTaskList, PUT);
    }
    public static void deleteTask(List<TodoTask__c> taskToDelete) {
        String jsonTaskList = convertToJson(taskToDelete);
        CallOutService.doCallOut(jsonTaskList, REMOVE);
    }

    public class JsonWrapper {
        String externalId { get; set; }
        String subject { get; set; }
        String origin { get; set; }
        String recordTypeName { get; set; }
        String category { get; set; }
        Boolean isComplete { get; set; }
    }
}
