/**
 * Created by Sergey on 25.10.2020.
 */

@IsTest  class TodoTaskDeleteOldBatchTest {

    @TestSetup static void setup() {
        Triggers.areDisabled = true;

        Date creationDate = Date.today() - 94;
        TodoTask__c task = new TodoTask__c(Category__c='Information');

        insert task;
        Test.setCreatedDate(task.Id, creationDate);
        update task;
    }

    @IsTest static void shouldReturnTasksOlderThan3Month() {
        Test.startTest();
        Triggers.areDisabled = true;
        TodoTaskDeleteOldBatch batch = new TodoTaskDeleteOldBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        List<TodoTask__c> oldTasks = [SELECT Id FROM TodoTask__c WHERE CreatedDate = LAST_90_DAYS];
        System.assertEquals(0, oldTasks.size());
    }
}
