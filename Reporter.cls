// Reporter.cls
public with sharing class Reporter {
    public List<String> runListW {get; set;}
    public List<String> runListS {get; set;}
    public Map<String, Decimal> counts {get; set;}
    public Map<String, Decimal> workgroupTotals {get; set;}
    public Map<String, Decimal> stageTotals {get; set;}
    public Set<String> workgroupSet {get; set;}
    public Set<String> stagenameSet {get; set;}

    public Reporter() {
        workgroupSet = new Set<String>();
        stagenameSet = new Set<String>();
        counts = new Map<String, Decimal>();
        workgroupTotals = new Map<String, Decimal>();
        stageTotals = new Map<String, Decimal>();
        createCrossTabData();
    }

    public void createCrossTabData() {
        List<resultMatrix> opportunityMatrix = getOpportunityMatrix();

        // Loop through the opportunity matrix data
        for (resultMatrix result : opportunityMatrix) {
            String workgroup = result.WorkGroup;
            String stage = result.StageName;
            Decimal amount = result.Amount;
    
            // Add the workgroup and stage to the sets
            workgroupSet.add(workgroup);
            stagenameSet.add(stage);
    
            // Add the amount to the counts map
            String key = workgroup + '-' + stage;
            counts.put(key, amount);
    
            // Add the amount to the workgroup totals map
            if (workgroupTotals.containsKey(workgroup)) {
                workgroupTotals.put(workgroup, workgroupTotals.get(workgroup) + amount);
            } else {
                workgroupTotals.put(workgroup, amount);
            }
    
            // Add the amount to the stage totals map
            if (stageTotals.containsKey(stage)) {
                stageTotals.put(stage, stageTotals.get(stage) + amount);
            } else {
                stageTotals.put(stage, amount);
            }
        }
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