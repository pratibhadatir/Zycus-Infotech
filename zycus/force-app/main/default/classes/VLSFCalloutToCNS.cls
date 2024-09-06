public class VLSFCalloutToCNS{
    
    @InvocableMethod(label='Make API Callout to CNS')
    public static void makeCNSApiCallout(List<Id> changeRequestIDs) {
        // Call the existing future method
        VLSFChangeRequestApi.makeApiCalloutCNS(new Set<Id>(changeRequestIDs));
    }
    
}