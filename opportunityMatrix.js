import { LightningElement, track, wire } from 'lwc';
import getOpportunityMatrix from '@salesforce/apex/ReportResourceController.getOpportunityMatrix';

export default class OpportunityMatrix extends LightningElement {
    @track matrixData = [];
    @track workgroupTotalsData = [];
    @track stageTotalsData = [];
    @track total = 0;

    @wire(getOpportunityMatrix)
    wiredOpportunityMatrix({ error, data }) {
        if (data) {
            let workgroupTotals = {};
            let stageTotals = {};
            this.matrixData = data.map(item => {
                const key = item.workgroupSet + '-' + item.stagenameSet;
                // Calculate workgroup totals
                if (workgroupTotals[item.workgroupSet]) {
                    workgroupTotals[item.workgroupSet] += item.count;
                } else {
                    workgroupTotals[item.workgroupSet] = item.count;
                }
                // Calculate stage totals
                if (stageTotals[item.stagenameSet]) {
                    stageTotals[item.stagenameSet] += item.count;
                } else {
                    stageTotals[item.stagenameSet] = item.count;
                }
                return {
                    ...item,
                    key: key,
                    count: item.count
                };
            });

            this.workgroupTotalsData = Object.keys(workgroupTotals).map(workgroup => {
                return {
                    workgroup: workgroup,
                    total: workgroupTotals[workgroup]
                };
            });

            this.stageTotalsData = Object.keys(stageTotals).map(stage => {
                return {
                    stage: stage,
                    total: stageTotals[stage]
                };
            });

            this.total = this.calculateTotal();
        } else if (error) {
            console.error(error);
        }    
    }

    calculateTotal() {
        return this.matrixData.reduce((total, item) => total + item.count, 0);
    }
}