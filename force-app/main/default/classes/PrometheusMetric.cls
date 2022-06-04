public without sharing class PrometheusMetric {
	public String name { get; set; }
	public Decimal value { get; set; }
	// Prometheus labels are string value pairs that can
	// allow us to target more
	public Map<String, String> labels;

	public PrometheusMetric() {
		this.labels = new Map<String, String>();
	}
}