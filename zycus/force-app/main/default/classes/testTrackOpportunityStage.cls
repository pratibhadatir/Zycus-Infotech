@isTest
public class testTrackOpportunityStage {
    
    
    private static testMethod void runTest() {
        Opportunity opp = new Opportunity(Name='Test Opportunity',StageName='Test Stage',CloseDate=Date.today()+180);
        insert opp;
        
        // First, let's make sure that when we add an Event to an Opportunity, the Opportunity Stage gets passed
        Event e1 = new Event(Subject='Test Event 1', StartDateTime=Datetime.now(),EndDateTime=Datetime.now()+1, whatID=opp.id);
        insert e1;
        System.debug('opp ID: '+opp.ID+'; opp stage: '+opp.stageName+'; event id: '+e1.id+'; event stage: '+e1.Opportunity_Stage__c);
        e1 = [SELECT Opportunity_Stage__c FROM Event WHERE ID =:e1.id];
        System.assertEquals(e1.Opportunity_Stage__c,opp.StageName);
        
        // Cool! Now let's make sure that if we update the Opportunity stage, the (still open) Event gets updated too
        opp.StageName = 'New Test Stage';
        update opp;
        opp = [SELECT StageName FROM Opportunity WHERE ID =: opp.id];        
        e1 = [SELECT Opportunity_Stage__c FROM Event WHERE ID =:e1.id];
        System.assertEquals(e1.Opportunity_Stage__c,opp.StageName);
        
        // Wicked! Now let's send the Event back in time, so that it's closed. Then we're going to update the Opportunity stage,
        // and hopefully the Opportunity Stage field on the Event does NOT get updated, since it's closed now
        e1.StartDateTime = Datetime.now()-10;
        e1.EndDateTime = Datetime.now()-9;
        update e1;
        opp.StageName = 'Third Test Stage';
        update opp;
        opp = [SELECT StageName FROM Opportunity WHERE ID =: opp.id];
        e1 = [SELECT Opportunity_Stage__c FROM Event WHERE ID =:e1.id];
        System.assertNotEquals(e1.Opportunity_Stage__c,opp.StageName);
        
        // Ok, last but not least for Events, let's put in an Event NOT attached to an Opportunity, and confirm that the
        // Opportunity Stage field stays blank
        Event e2 = new Event(Subject='Test Event 2',StartDateTime=Datetime.now(),EndDateTime=Datetime.now()+1);
        insert e2;
        e2 = [SELECT Opportunity_Stage__c FROM Event WHERE ID =:e2.id];
        System.assertEquals(e2.Opportunity_Stage__c,null);


        // Next, let's test the Tasks
        // In order to set a Task's isClosed value, we need this backwards route of using TaskStatus. I dunno.
        TaskStatus openStatus = [SELECT IsClosed, MasterLabel FROM TaskStatus WHERE IsClosed = false LIMIT 1];
        System.debug('Status '+openStatus.MasterLabel+' is Closed? '+openStatus.IsClosed);
        TaskStatus closedStatus = [SELECT IsClosed, MasterLabel FROM TaskStatus WHERE IsClosed = true LIMIT 1];        
        System.debug('Status '+closedStatus.MasterLabel+' is Closed? '+closedStatus.IsClosed);
        
        // Ok, so let's confirm that a newly inserted OPEN task gets the Opportunity's stage value
        Task t1 = new Task(Subject='Test Task 1',whatID=opp.id,Status=openStatus.MasterLabel);
        insert t1;
        t1 = [SELECT Opportunity_Stage__c, Status, IsClosed FROM Task WHERE ID =:t1.id];        
        System.assertEquals(t1.Opportunity_Stage__c,opp.StageName);
        
        System.debug('t1 has a status of '+t1.Status+', isclosed='+t1.isClosed);
        
        // Next, let's change the Opportunity's Stage value and (just for fun) confirm that it doesn't update the Task's OpStage value
        opp.StageName = 'Yet another test stage';
        update opp;
        opp = [SELECT StageName FROM Opportunity WHERE ID =: opp.id];
        t1 = [SELECT Opportunity_Stage__c, Status, IsClosed FROM Task WHERE ID =:t1.id];        
        System.assertNotEquals(t1.Opportunity_Stage__c,opp.StageName);
        
        // Groovy! Now let's close that Task, and confirm that it now DOES match the Opportunity's Stage value
        t1.Status = closedStatus.MasterLabel;
        System.debug('!!! About to close the task');
        update t1;
        t1 = [SELECT Opportunity_Stage__c, Status, IsClosed FROM Task WHERE ID =:t1.id];        
        System.debug('t1 now has a status of '+t1.Status+', isclosed='+t1.isClosed);        
        System.assertEquals(t1.Opportunity_Stage__c,opp.StageName);        
        
        // Penultimately, let's insert a pre-closed Task and confirm that it also gets the Opportunity's stage value
        Task t2 = new Task(Subject='Test Task 2',whatID=opp.id,Status=closedStatus.MasterLabel);
        insert t2;
        t2 = [SELECT Opportunity_Stage__c FROM Task WHERE ID =:t2.id];        
        System.assertEquals(t2.Opportunity_Stage__c,opp.StageName);

        Task t3 = new Task(Subject='Test Task 3');
        insert t3;
        t3 = [SELECT Opportunity_Stage__c FROM Task WHERE ID =:t3.id];                
        System.assertEquals(t3.Opportunity_Stage__c,null);
        


    }

}