public without sharing class LimitsMetricsProvider extends MetricsProvidable {
	public static final Integer CONVERSION_MB_TO_BYTES = 1024 * 1024;

	// Prometheus reports in base metric of bytes whereas Salesforce data limits
	// are expressed in MB. This list has all those data limits that need
	// to be converted to bytes.
	public static final String[] CONVERTBYTES = new List<String>{
		'AnalyticsExternalDataSizeMB',
		'DailyAnalyticsUploadedFilesSizeMB',
		'DailyBulkV2QueryFileStorageMB',
		'DataStorageMB',
		'FileStorageMB'
	};

	// Format `sfdc_limits_<metricnamelowercase>_max`, `sfdc_limits_<metricnamelowercase>_remaining`.
	// Ex: `sfdc_limits_dailyapirequests_max`, ``sfdc_limits_dailyapirequests_remaining`.
	public static final String FORMAT = 'sfdc_limits_{0}_{1}';
	public static final String FORMAT_BYTES = 'sfdc_limits_{0}_{1}_bytes';

	public LimitsMetricsProvider() {
		this.model = new LimitsMetricsModel();
	}

	public override List<PrometheusMetric> getMetricsForPrometheus() {
		return createMetricsForPrometheus(this.model.getData());
	}

	private List<PrometheusMetric> createMetricsForPrometheus(List<Metric> metrics) {
		List<PrometheusMetric> prometheusMetrics = new List<PrometheusMetric>();
		for (Metric aMetric : metrics) {
			Boolean isDataSizeMetric = CONVERTBYTES.contains(aMetric.name);
			PrometheusMetric max = createPrometheusMetric(aMetric.name, aMetric.max, isDataSizeMetric, true);
			PrometheusMetric current = createPrometheusMetric(aMetric.name, aMetric.value, isDataSizeMetric, false);
		
			prometheusMetrics.add(max);
			prometheusMetrics.add(current);
		}
		return prometheusMetrics;
	}

	private PrometheusMetric createPrometheusMetric(
		String name,
		Integer metric,
		Boolean isDataSizeMetric,
		Boolean isMax
	) {
		String format = isDataSizeMetric ? FORMAT_BYTES : FORMAT;
		Integer conversion = isDataSizeMetric ? CONVERSION_MB_TO_BYTES : 1;
		String suffix = isMax ? 'max' : 'current';
		
		PrometheusMetric metricToCreate = new PrometheusMetric();
		metricToCreate.value = (Decimal) metric * conversion;
		metricToCreate.name = String.format(
			format,
			new List<String>{name.toLowercase(), suffix}
		);
		metricToCreate.labels = this.metricsLabel;

		return metricToCreate;
	}
}