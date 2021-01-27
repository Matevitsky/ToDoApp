/**
 * Created by Sergey on 25.10.2020.
 */

public with sharing class TodoTaskSchedulableJob implements Schedulable {

    public void execute(SchedulableContext param1) {
        TodoTaskDeleteOldBatch taskDeleteOldBatch = new TodoTaskDeleteOldBatch();
        Database.executeBatch(taskDeleteOldBatch);
    }
}
