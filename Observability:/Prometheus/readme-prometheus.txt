Scrape Metrics from the App (e.g., Request Latency, Error Rates)

To scrape metrics from the FastAPI application, you can use Prometheus as the monitoring tool. The FastAPI app needs to expose metrics in a format that Prometheus can scrape. This can be achieved using the prometheus-fastapi-instrumentator library.

Steps to Implement:

Install Prometheus Instrumentation Library:
Add the prometheus-fastapi-instrumentator library to your FastAPI app.

pip install prometheus-fastapi-instrumentator

The Instrumentator automatically collects metrics like request latency, error rates, and request counts