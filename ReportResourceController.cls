// ReportResourceController.cls
public with sharing class ReportResourceController {
    @AuraEnabled(cacheable=true)
    public static List<resultMatrix> getOpportunityMatrix() {
        reportResource resource = new reportResource();
        return resource.getOpportunityMatrix();
    }
}