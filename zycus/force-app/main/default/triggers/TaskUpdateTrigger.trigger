trigger TaskUpdateTrigger on Task (after insert, after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        for (Task task : Trigger.new) {
            if (task.VLSF_Task_Created__c == true) {
                ChangeRequestTaskUpdater.updateChangeRequestCheckbox1(Trigger.new);
                break; // Exit loop after updating one task
            }
        }
    }
}