@isTest
public class LimitsMetricsProviderTest {
	private static final String PREFIX = 'sfdc_limits_';
	private static final String SUFFIX_MAX = '_max';
	private static final String SUFFIX_CURRENT = '_current';

	@isTest
	static void getMetricsTest() {
		List<Organization> orgs = [SELECT IsSandbox FROM Organization];
		final String[] CONVERTBYTES = new List<String>{
			'AnalyticsExternalDataSizeMB',
			'DailyAnalyticsUploadedFilesSizeMB',
			'DailyBulkV2QueryFileStorageMB',
			'DataStorageMB',
			'FileStorageMB'
		};

		// When
		Test.startTest();
		MetricsProvidable limitsProvider = new LimitsMetricsProvider(); 
		limitsProvider.model = new TestMetricsModel();
		List<PrometheusMetric> allLimits = limitsProvider.getMetricsForPrometheus();
		Test.stopTest();

		// Then
		String environment = (!orgs.isEmpty() && orgs[0].IsSandbox) ? 'int' : 'prod';
		
		Map<String, PrometheusMetric> metricMap = new Map<String, PrometheusMetric>();
		for(PrometheusMetric metric : allLimits) {
			metricMap.put(metric.name, metric);
		}

		String concurrentasyncgetreportinstancesMaxKey = PREFIX + 'concurrentasyncgetreportinstances' + SUFFIX_MAX;
		System.assertEquals(200, metricMap.get(concurrentasyncgetreportinstancesMaxKey).value, 'concurrentasyncgetreportinstances max should be 200');
		System.assert(metricMap.get(concurrentasyncgetreportinstancesMaxKey).labels.get('environment') == environment, 'environment should match');
		
		String concurrentasyncgetreportinstancesCurrentKey = PREFIX + 'concurrentasyncgetreportinstances' + SUFFIX_CURRENT;
		System.assertEquals(150, metricMap.get(concurrentasyncgetreportinstancesCurrentKey).value, 'concurrentasyncgetreportinstances current should be 150');
		System.assert(metricMap.get(concurrentasyncgetreportinstancesCurrentKey).labels.get('environment') == environment, 'environment should match');

		String dailyapirequestsMaxKey = PREFIX + 'dailyapirequests' + SUFFIX_MAX;
		System.assertEquals(7136000, metricMap.get(dailyapirequestsMaxKey).value, 'dailyapirequests max should be 7136000');
		System.assert(metricMap.get(dailyapirequestsMaxKey).labels.get('environment') == environment, 'environment should match');
		
		String dailyapirequestsCurrentKey = PREFIX + 'dailyapirequests' + SUFFIX_CURRENT;
		System.assertEquals(3333, metricMap.get(dailyapirequestsCurrentKey).value, 'dailyapirequests current should be 3333');
		System.assert(metricMap.get(dailyapirequestsCurrentKey).labels.get('environment') == environment, 'environment should match');

		String datastoragembMaxKey = PREFIX + 'datastoragemb' + SUFFIX_MAX + '_bytes';
		System.assertEquals(234 * 1024 * 1024, metricMap.get(datastoragembMaxKey).value, 'datastoragemb max should be 234 * 1024 * 1024');
		System.assert(metricMap.get(datastoragembMaxKey).labels.get('environment') == environment, 'environment should match');
		
		String datastoragembCurrentKey = PREFIX + 'datastoragemb' + SUFFIX_CURRENT + '_bytes';
		System.assertEquals(45 * 1024 * 1024, metricMap.get(datastoragembCurrentKey).value, 'datastoragemb current should be 45 * 1024 * 1024');
		System.assert(metricMap.get(datastoragembCurrentKey).labels.get('environment') == environment, 'environment should match');
	}
}