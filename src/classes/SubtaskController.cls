/**
 * Created by MKA on 19.10.2020.
 */

public class SubtaskController {


    @AuraEnabled (Cacheable=true)
    public static List<Subtask__c> getSubtasks(Id taskId) {
        return [
                SELECT Id, Name, Date__c, TodoTask__c
                FROM Subtask__c
                WHERE TodoTask__c = :taskId
        ];
    }


    @AuraEnabled
    public static Subtask__c insertSubtask(String subtaskName, Id taskId) {
        try {
            Subtask__c subtask = new Subtask__c(
                    Name = subtaskName,
                    TodoTask__c = taskId
            );
           insert subtask;
            return subtask;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return null;
    }

    @AuraEnabled
    public static Boolean deleteSubtask(Id recordId) {
        try {
            Database.delete(recordId);
            return true;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return false;
    }
}
