public class CaseMilestoneChecker {

    /**
     * Checks if there are any CaseMilestones associated with a given Case.
     *
     * @param caseId The Id of the Case to check.
     * @return Boolean indicating whether there are associated CaseMilestones.
     */
    public static Boolean isMilestoneAttachedToCase(Id caseId) {
        // Query CaseMilestone records associated with the specified CaseId
        List<CaseMilestone> milestones = [
            SELECT Id
            FROM CaseMilestone
            WHERE CaseId = :caseId
        ];
        
        // Return true if any CaseMilestone records are found, otherwise false
        return !milestones.isEmpty();
    }
}