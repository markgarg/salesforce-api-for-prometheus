public with sharing class TestMetricsModel implements MetricsModel {
	private List<Metric> data;

	public TestMetricsModel() {
		this.data = getTestData();
	}

	public TestMetricsModel(List<Metric> input) {
		this.data = input;
	}

    public List<Metric> getData() {
        return this.data;
    }

    private List<Metric> getTestData() {
        return new List<Metric> {
			new Metric('AnalyticsExternalDataSizeMB', 0, 40960),
			new Metric('BOZosCalloutHourlyLimit', 20000, 20000),
			new Metric('ConcurrentAsyncGetReportInstances', 150, 200),
			new Metric('ConcurrentEinsteinDataInsightsStoryCreation', 5, 5),
			new Metric('ConcurrentEinsteinDiscoveryStoryCreation', 2, 2),
			new Metric('ConcurrentSyncReportRuns', 20, 20),
			new Metric('DailyAnalyticsDataflowJobExecutions', 60, 60),
			new Metric('DailyAnalyticsUploadedFilesSizeMB', 51200, 51200),
			new Metric('DailyApiRequests', 3333, 7136000),
			new Metric('Chatter Desktop', 0, 0),
			new Metric('Chatter Mobile for BlackBerry', 0, 0),
			new Metric('DAP Streaming API', 0, 0),
			new Metric('Dataloader Bulk', 0, 0),
			new Metric('Dataloader Partner', 0, 0),
			new Metric('EinsteinDashboardUSApp', 0, 0),
			new Metric('Force.com IDE', 0, 0),
			new Metric('Integration Tests', 0, 0),
			new Metric('Internal Metadata API Access', 0, 0),
			new Metric('Natterbox 01', 0, 0),
			new Metric('Natterbox 02', 0, 0),
			new Metric('NatterboxAuth', 0, 0),
			new Metric('NowTV API', 0, 0),
			new Metric('Salesforce Chatter', 0, 0),
			new Metric('Salesforce Files', 0, 0),
			new Metric('Salesforce Mobile Dashboards', 0, 0),
			new Metric('Salesforce Touch', 0, 0),
			new Metric('Salesforce for Android', 0, 0),
			new Metric('Salesforce for Outlook', 0, 0),
			new Metric('Salesforce for iOS', 0, 0),
			new Metric('DailyBulkV2QueryFileStorageMB', 200, 200),
			new Metric('DataStorageMB', 45, 234),
			new Metric('FileStorageMB', 39, 100)
		};
    }
}