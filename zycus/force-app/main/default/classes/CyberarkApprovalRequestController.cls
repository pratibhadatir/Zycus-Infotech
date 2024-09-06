public with sharing class CyberarkApprovalRequestController {
    public Case caseRecord { get; set; }
    public Cyberark_Approval_Request__c request { get; set; }

    public CyberarkApprovalRequestController(ApexPages.StandardController controller) {
        this.caseRecord = (Case)controller.getRecord();
        this.request = new Cyberark_Approval_Request__c();
        this.request.Case__c = caseRecord.Id;
    }

    public PageReference save() {
        try {
            insert request;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Cyberark Approval Request created successfully.'));
            PageReference pr = new PageReference('/' + request.Id);
            pr.setRedirect(true);
            return pr;
        } catch (DmlException e) {
            ApexPages.addMessages(e);
            return null;
        }
    }

    public PageReference cancel() {
        return new PageReference('/' + caseRecord.Id);
    }
}