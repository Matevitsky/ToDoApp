/**
 * Created by MKA on 23.10.2020.
 */

trigger TodoTaskTrigger on TodoTask__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if (Triggers.areDisabled) return;

    if (Trigger.isUpdate && Trigger.isAfter) {
        TodoTaskTriggerHandler.afterUpdate(Trigger.new);
    }
    else if (Trigger.isUpdate && Trigger.isBefore) {
    }
    else if (Trigger.isInsert && Trigger.isBefore) {
    }
    else if (Trigger.isInsert && Trigger.isAfter) {
        TodoTaskTriggerHandler.afterInsert(Trigger.new);
    }
    else if (Trigger.isDelete && Trigger.isBefore) {
        TodoTaskTriggerHandler.beforeDelete(Trigger.old);
    }
    else if (Trigger.isDelete && Trigger.isAfter) {
    }
    else if (Trigger.isUndelete && Trigger.isAfter) {

    }
}
