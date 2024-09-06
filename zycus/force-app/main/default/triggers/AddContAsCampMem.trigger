// Test Class Name: test_AddContAsCampMem
trigger AddContAsCampMem on Contact (After Insert, After Update) {
	DataThroughDataLoader__c mhc = DataThroughDataLoader__c.getInstance();
    Boolean status = mhc.UsingDataLoader__c;
    if(status == False) {
        if(trigger.isUpdate && trigger.isAfter) {
            list<string> CampaignNames = new list<string>();
            list<string> CampaignType = new list<string>();
            for(Contact Con: trigger.new) {
                if((Con.Secondary_Source__c != null && Con.Secondary_Source__c != trigger.oldMap.get(con.Id).Secondary_Source__c) ||
                   (Con.Opportunity_Source__c != null && Con.Opportunity_Source__c != trigger.oldMap.get(con.Id).Opportunity_Source__c))
                    {
                       CampaignNames.add(Con.Secondary_Source__c);
                       CampaignType.add(Con.Opportunity_Source__c);
                   }
            }
            system.debug('CampaignNames ====> ' + CampaignNames);
            system.debug('CampaignType ====> ' + CampaignType);
            list<Campaign> campaignList = new list<Campaign>([select id, name, type from Campaign where name in :CampaignNames AND Type in: CampaignType]);
            map<string, Campaign> campaignName_CampaignMap = new map<string, campaign>();
            map<string, Campaign> campaignType_CampaignMap = new map<string, campaign>();
            for(campaign camp: campaignList) {
                if(camp.Name != null && camp.Type != null) {
                    campaignName_CampaignMap.put(camp.name.toLowerCase(), Camp);
                    campaignType_CampaignMap.put(camp.Type.toLowerCase(), Camp);
                }
            }
            List<CampaignMember> oldCampMemList = new list<CampaignMember>();
            List<campaignmember> newCampMemList = new list<campaignmember>();
            for(Contact con: trigger.new) {
                if(Con.Secondary_Source__c != null && Con.Opportunity_Source__c != null) {
                    Campaign camp = campaignName_CampaignMap.get(Con.Secondary_Source__c.toLowerCase());
                    Campaign campType = campaignType_CampaignMap.get(Con.Opportunity_Source__c.toLowerCase());
                    if(camp != null && campType != null) {
                        CampaignMember cm = new CampaignMember();
                        cm.CampaignId = camp.Id;
                        cm.ContactId = con.Id;
                        newCampMemList.add(cm);
                    }
                }
            }
            try {
                if(newCampMemList.size() > 0) {
                    insert newCampMemList;
                }
            }
            catch(exception e) {
                system.debug(e.getMessage());
            }
        }
        if(trigger.isInsert && trigger.isAfter) {
            list<string> CampaignNames = new list<string>();
            list<string> CampaignType = new list<string>();
            for(Contact Con : trigger.new){
                if(Con.Secondary_Source__c != null && Con.Opportunity_Source__c != null) {
                    CampaignNames.add(Con.Secondary_Source__c);
                    CampaignType.add(Con.Opportunity_Source__c);
                }
            }
            system.debug('CampaignNames ====> ' + CampaignNames);
            system.debug('CampaignType ====> ' + CampaignType);
            list<Campaign> campaignList = new list<Campaign>([select id, name, type from Campaign where name in :CampaignNames AND Type in: CampaignType]);
            map<string, Campaign> campaignName_CampaignMap = new map<string, campaign>();
            map<string, Campaign> campaignType_CampaignMap = new map<string, campaign>();
            for(campaign camp: campaignList) {
                if(camp.Name != null && camp.Type != null) {
                    campaignName_CampaignMap.put(camp.name.toLowerCase(), Camp);
                    campaignType_CampaignMap.put(camp.Type.toLowerCase(), Camp);
                }
            }
            List<campaignmember> cmList = new list<campaignmember>();
            for(Contact con: trigger.new) {
                if(Con.Secondary_Source__c != null && Con.Opportunity_Source__c != null) {
                    Campaign camp = campaignName_CampaignMap.get(Con.Secondary_Source__c.toLowerCase());
                    Campaign campType = campaignType_CampaignMap.get(Con.Opportunity_Source__c.toLowerCase());
                    if(camp != null) {
                        CampaignMember cm = new CampaignMember();
                        cm.CampaignId = camp.Id;
                        cm.ContactId = con.Id;
                        cmList.add(cm);
                    }
                }
            }
            if(cmList.size() > 0) {
                insert cmList;
            }
        }
    }
}