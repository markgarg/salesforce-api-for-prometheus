@isTest
private class PrometheusAPITest {
	private static final Integer HTTP_STATUS_CODE_OK = 200;

	@isTest
	static void itShouldReturnGovLimits() {
		// Given
		MetricsProvidable limitsProvider = new LimitsMetricsProvider(); 
		limitsProvider.model = getFewLimitsBody(10000, 2000);
		List<MetricsProvidable> testProviders = new List<MetricsProvidable>{limitsProvider};
		PrometheusAPI.providers = testProviders;
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/api/v1/prometheus';
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;

		// When
		Test.startTest();
		PrometheusAPI.getAllMetrics();
		Test.stopTest();

		// Then
		List<Organization> orgs = [SELECT IsSandbox FROM Organization];
		String environment = (!orgs.isEmpty() && orgs[0].IsSandbox) ? 'int' : 'prod';
		String label = '{environment="' +
			environment +
			'"}';
		String expectedResponse =
			'sfdc_limits_dailyapirequests_max' +
			label +
			' 40960' +
			'\n' +
			'sfdc_limits_dailyapirequests_current' +
			label +
			' 10000' +
			'\n' +
			'sfdc_limits_dailyasyncapexexecutions_max' +
			label +
			' 250000' +
			'\n' +
			'sfdc_limits_dailyasyncapexexecutions_current' +
			label +
			' 0' +
			'\n' +
			'sfdc_limits_dailybulkapirequests_max' +
			label +
			' 5000' +
			'\n' +
			'sfdc_limits_dailybulkapirequests_current' +
			label +
			' 2000';
		System.assertEquals(HTTP_STATUS_CODE_OK, RestContext.response.statusCode, 'should be successful');
		System.assertEquals(expectedResponse, RestContext.response.responseBody.toString(), 'expected response should match actual');
	}

	@isTest
	static void itShouldReturnFileStorageInBytesGovLimits() {
		// Given
		MetricsProvidable limitsProvider = new LimitsMetricsProvider(); 
		limitsProvider.model = getStorageLimitsBody(1024, 2048);
		List<MetricsProvidable> testProviders = new List<MetricsProvidable>{limitsProvider};
		PrometheusAPI.providers = testProviders;

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/api/v1/prometheus';
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;

		// When
		Test.startTest();
		PrometheusAPI.getAllMetrics();
		Test.stopTest();

		// Then
		System.assertEquals(HTTP_STATUS_CODE_OK, RestContext.response.statusCode, 'should be successful');

		List<Organization> orgs = [SELECT IsSandbox FROM Organization];
		String environment = (!orgs.isEmpty() && orgs[0].IsSandbox) ? 'int' : 'prod';
		String label = '{environment="' +
			environment +
			'"}';
		String expectedResponse =
			'sfdc_limits_datastoragemb_max_bytes' +
			label +
			' 10737418240' +
			'\n' +
			'sfdc_limits_datastoragemb_current_bytes' +
			label +
			' 1073741824' +
			'\n' +
			'sfdc_limits_filestoragemb_max_bytes' +
			label +
			' 21474836480' +
			'\n' +
			'sfdc_limits_filestoragemb_current_bytes' +
			label +
			' 2147483648';
		System.assertEquals(expectedResponse, RestContext.response.responseBody.toString(), 'storage response should match');
	}

	static TestMetricsModel getFewLimitsBody(Integer currentApiCount, Integer currentBulkApiCount) {
		List<Metric> metrics = new List<Metric> {
			new Metric('DailyApiRequests', currentApiCount, 40960),
			new Metric('DailyAsyncApexExecutions', 0, 250000),
			new Metric('DailyBulkApiRequests', currentBulkApiCount, 5000)
		};

		return new TestMetricsModel(metrics);
	}

	static TestMetricsModel getStorageLimitsBody(Integer currentDataStorage, Integer currentFileStorage) {
		List<Metric> metrics = new List<Metric> {
			new Metric('DataStorageMB', currentDataStorage, 10240),
			new Metric('FileStorageMB', currentFileStorage, 20480)
		};

		return new TestMetricsModel(metrics);
	}
}