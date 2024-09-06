trigger ActivityTrigger on Task (after insert, after update) {
    ActivityTriggerHandler handler = new ActivityTriggerHandler();
    handler.updateCallCount(Trigger.New);
}