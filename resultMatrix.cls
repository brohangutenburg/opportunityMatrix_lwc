// resultMatrix.cls
public with sharing class resultMatrix {
    public String workgroupSet { get; set; }
    public String stagenameSet { get; set; }
    public Decimal Amount { get; set; }

    public resultMatrix(AggregateResult ar) {
        workgroupSet = (String) ar.get('Work_Group__c');
        stagenameSet = (String) ar.get('StageName');
        Amount = (Decimal) ar.get('expr0');
    }
}