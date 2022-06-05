# salesforce-api-for-prometheus
Exposes a simple API that Prometheus can call to scrape metrics

## Steps

1. Deploy the code
2. Create a public site
3. Give access to the `PrometheusAPI` class to the site guest user
    a. Go to the site and click on `Public Access Settings`
    b. Add `PrometheusAPI` to the `Enabled Apex Class Access`
4. Navigate to `<public site url>/services/apexrest/api/v1/prometheus` to view the API!
