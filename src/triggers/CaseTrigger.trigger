/**
 * Created by MKA on 22.10.2020.
 */

trigger CaseTrigger on Case (before insert, before update, before delete,
        after insert, after update, after delete, after undelete) {
    if (Triggers.areDisabled) return;

    CaseTriggerHandler handler = new CaseTriggerHandler();

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            handler.beforeInsert(Trigger.new);
        }

        if (Trigger.isUpdate) {

        }
    }

    else if (Trigger.isInsert && Trigger.isAfter) {
    }

    else if (Trigger.isUpdate && Trigger.isAfter) {
    }

    else if (Trigger.isDelete && Trigger.isBefore) {
    }

    else if (Trigger.isDelete && Trigger.isAfter) {
    }

    else if (Trigger.isUndelete && Trigger.isAfter) {
    }
}
