# Grafana

Welcome to this part of our workshop. We will introduce you to a powerful tools called **Prometheus**, that includes **Grafana**.

**Prometheus** is a piece of free software, written to monitor the health of your services and infrastructure in real-time. It does so by sending HTTP calls in real-time and stores the gathered data in a time series database.

**Grafana** is a tool, that can be used to create and view dashboards, so you can actually get some meaningful interpretation of the gathered data. In combination, these tools are extremely powerful, and have become even the de-facto standard monitoring system for Kubernetes.

We're lucky, that GitLab comes shipped with an built-in Prometheus integration that is enabled by default (See `Menu -> Admin -> Settings -> Metrics and profiling -> Metrics - Prometheus`), so we just have to connect the systems.

## Start up Grafana

Starting Grafana should be straightforward. Just run it using docker compose in this directory. It will boot and should be reachable at [http://localhost:4000](http://localhost:4000). Alternatively you can use the make command.

```bash
docker-compose up -d
```

## Log in to Grafana

Now that we've enabled Prometheus in GitLab, we have to set up our Grafana Dashboard. Maybe you've already noticed, that our `docker-compose.yml` already contains a container, running on port 4000. Therefore, you just have to access [http://localhost:4000](http://localhost:4000) and log in with the with the `admin` user using the default password which is `admin`. Grafana will ask to change password - please do so and don't forget.

## Adding Datasource to Grafana

Now you have to navigate to `Configuration -> Datasources` and create a new data source of type **Prometheus** with the following values:

* URL: `http://gitlab-ci:9090`  (Our internal container URL)

Leave the remaining default values, then click Save and Test. Your data source should have been successfully added to your instance of Grafana.

## Add a Dashboard

As some data in a time series database doesn't help us that much actually, we want to present the data that is important to us in a meaningful and comprehensible way. With Grafana you can do that.

Therefore, navigate to `Compass -> Explore Dashboard` and create three separate panels for `gitlab-rails`:

* `gitlab_blob_size_sum`
* `gitlab_ci_trace_bytes_total`
* `gitlab_ci_pipeline_processing_events_total`

Apply and Save the new dashboard.

## Test it

To actually test the dashboard, just run the simple pipeline we've created earlier a few times and observe the dashboard panels.
