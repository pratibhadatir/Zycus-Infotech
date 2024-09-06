public with sharing class OpportunityController {
    public Opportunity opportunity {get; set;}
    public Boolean editMode {get; set;}
    public Id contactRoleIdToDelete {get; set;}
    
    public OpportunityController(ApexPages.StandardController controller) {
        opportunity = (Opportunity)controller.getRecord();
        editMode = false; // Set initial edit mode
    }

    public void toggleEdit() {
        editMode = true;
    }

    public PageReference save() {
        // Perform save operation here
        editMode = false; // Exit edit mode after save
        return null;
    }

    public PageReference cancel() {
        editMode = false; // Exit edit mode on cancel
        return null;
    }

    public PageReference deleteContactRole() {
        if (contactRoleIdToDelete != null) {
            try {
                delete new List<OpportunityContactRole>{new OpportunityContactRole(Id = contactRoleIdToDelete)};
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred while deleting the contact role.'));
                return null;
            }
        } 
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));
    }
}