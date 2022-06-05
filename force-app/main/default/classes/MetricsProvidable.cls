// Can't expose Organization table to site guest user, hence suppressing it.
@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing abstract class MetricsProvidable {
	public static final String LABEL_ENVIRONMENT_PRODUCTION = 'prod';
	public static final String LABEL_ENVIRONMENT_NONTPRODUCTION = 'int';
	public static final String LABEL_ENVIRONMENT = 'environment';
	public static String environment;
	public Map<String, String> metricsLabel;
	public MetricsModel model {get; set;}

	public MetricsProvidable() {
		List<Organization> orgs = [SELECT IsSandbox FROM Organization];
		environment = (!orgs.isEmpty() && orgs[0].IsSandbox)
			? LABEL_ENVIRONMENT_NONTPRODUCTION
			: LABEL_ENVIRONMENT_PRODUCTION;

		this.metricsLabel = new Map<String, String>{
			LABEL_ENVIRONMENT => environment
		};
	}

	public abstract List<PrometheusMetric> getMetricsForPrometheus();
}