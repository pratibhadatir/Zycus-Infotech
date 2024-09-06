global class VLSF_RestrictEmailToCaseScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Schedule the batch job
        VLSF_RestrictEmailToCaseBatch batch = new VLSF_RestrictEmailToCaseBatch();
        Database.executeBatch(batch);
    }
}