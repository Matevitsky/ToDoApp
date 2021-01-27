/**
 * Created by MKA on 22.10.2020.
 */

public  class CaseTriggerHandler {

    public void beforeInsert(List<Case> newCases) {
        List<TodoTask__c> tasksList = new List<TodoTask__c>();

        for (Case testCase : newCases) {

            if (testCase.Origin == 'Email') {
                System.debug('Test case '+testCase);
                TodoTask__c newTask = new TodoTask__c();
                newTask.Name = testCase.Subject;
                newTask.Category__c = 'Information';
                newTask.Description__c = testCase.Description;
                newTask.Origin__c = 'Case';
                tasksList.add(newTask);
            }
            System.debug('test 3' + tasksList);

        }
        if (tasksList.size() > 0) {
            insert tasksList;
        }
    }
}
