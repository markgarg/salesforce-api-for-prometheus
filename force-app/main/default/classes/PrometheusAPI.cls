@RestResource(urlMapping='/api/v1/prometheus')
global without sharing class PrometheusAPI {
	global static final String FORMAT = '{0}{1} {2}';
    global static final String NEW_LINE = '\n';
	global static final String OPEN_CURLY_BRACKET = '{';
	global static final String CLOSED_CURLY_BRACKET = '}';
	global static final String DOUBLE_QUOTES = '"';
	global static final String EQUAL_TO = '=';

	@TestVisible
	static List<MetricsProvidable> providers;

	@HttpGet
	global static void getAllMetrics() {
		List<PrometheusMetric> allMetrics = new List<PrometheusMetric>();

		for (MetricsProvidable provider : getProviders()) {
			try {
				allMetrics.addAll(provider.getMetricsForPrometheus());
			} catch (Exception ex) {
				// Log error and fail silently as we don't want API to fail
				System.debug(LoggingLevel.ERROR, 'Failed to get metrics :' + ex.getMessage());
				System.debug(LoggingLevel.ERROR, 'Failed to get metrics :' + ex.getStackTraceString());
			}
		}
		// Convert to string
		String metricsResponse = convertAllMetricsToString(allMetrics);

		RestResponse restResponse = RestContext.response;
		restResponse.statusCode = 200;
		restResponse.responseBody = Blob.valueOf(metricsResponse);
	}

	private static List<MetricsProvidable> getProviders() {
		// This allows us to set test data in tests 
		if(providers == null) {
			providers = new List<MetricsProvidable>{new LimitsMetricsProvider()};
		}
		return providers;
	}

	private static String convertAllMetricsToString(List<PrometheusMetric> allMetrics) {
		String response = '';
		for (PrometheusMetric met : allMetrics) {
			if (String.isNotBlank(response)) {
				response += NEW_LINE;
			}
			response += stringifyMetric(met);
		}
		return response;
	}

	private static String stringifyMetric(PrometheusMetric metric) {
		if (metric == null) {
			return '';
        }

		String labels = OPEN_CURLY_BRACKET;
		for (String labelName : metric.labels.keySet()) {
			if (!'{'.equals(labels)) {
				labels += ',';
			}
			labels += labelName;
			labels += EQUAL_TO;
			labels +=
				DOUBLE_QUOTES +
				metric.labels.get(labelName) +
				DOUBLE_QUOTES;
		}
		labels += CLOSED_CURLY_BRACKET;
		return String.format(
			FORMAT,
			new List<String>{metric.name, labels, String.valueOf(metric.value)}
		);
	}
}