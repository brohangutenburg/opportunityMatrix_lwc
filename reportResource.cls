// reportResource.cls
public with sharing class reportResource {
    public List<String> runListW {get; set;}
    public List<String> runListS {get; set;}
    public Map<String, Decimal> counts {get; set;}
    public Map<String, Decimal> workgroupTotals {get; set;}
    public Map<String, Decimal> stageTotals {get; set;}
    public Set<String> workgroupSet {get; set;}
    public Set<String> stagenameSet {get; set;}

    public reportResource() {
        createCrossTabData();
    }

    public void createCrossTabData() {
        // Your existing code to populate the counts, workgroupTotals, and stageTotals maps...

        // Convert the workgroupSet and stagenameSet sets to sorted lists
        runListW = new List<String>(workgroupSet);
        runListW.sort();
        runListS = new List<String>(stagenameSet);
        runListS.sort();
    }

    public Decimal getTotal() {
        Decimal total = 0;
        for (Decimal workgroupTotal : workgroupTotals.values()) {
            total += workgroupTotal;
        }
        return total;
    }

    public List<resultMatrix> getOpportunityMatrix() {
        List<resultMatrix> oppToStore = new List<resultMatrix>();
        for (AggregateResult result : [
            SELECT Work_Group__c, StageName, SUM(Amount)
            FROM OPPORTUNITY
            WHERE Work_Group__c IN ('Medical', 'Safety', 'Inspection', 'Professional Services')
            GROUP BY Work_Group__c, StageName
        ]) {
            resultMatrix objResultMatrix = new resultMatrix(result); 
            oppToStore.add(objResultMatrix);
        }
        return oppToStore;
    }
}