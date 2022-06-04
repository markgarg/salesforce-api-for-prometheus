public with sharing class LimitsMetricsModel implements MetricsModel {
    public List<Metric> getData() {
        return convert(System.OrgLimits.getAll());
    }

    private List<Metric> convert(List<System.OrgLimit> orgLimits) {
        List<Metric> metrics = new List<Metric>();

        for(System.OrgLimit aLimit : orgLimits){
            Metric met = new Metric(
                aLimit.getName(),
                aLimit.getValue(),
                aLimit.getLimit()
            );

            metrics.add(met);
        }

        return metrics;
    }
}