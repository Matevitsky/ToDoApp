/**
 * Created by Sergey on 25.10.2020.
 */

public with sharing class TodoTaskDeleteOldBatch implements Database.Batchable<TodoTask__c> {


    public List<TodoTask__c> start(Database.BatchableContext param1) {
        return [SELECT Id FROM TodoTask__c WHERE CreatedDate = LAST_N_MONTHS:3];
    }
    public void execute(Database.BatchableContext param1, List<TodoTask__c> oldTasks) {

        delete oldTasks;
    }

    public void finish(Database.BatchableContext param1) {

    }

}
