trigger ActivityTriggers on Task (after insert, after update) {
    ActivityTriggerHandlers handler = new ActivityTriggerHandlers();
    handler.updateContactStatus(Trigger.New);
}