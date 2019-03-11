# docker-promtool

Minimal docker image for running the promtool utility for validating prometheus config files.

## Why?

We our currently keeping all prometheus config files under source control at (https://github.com/eeveebank/monitoring-resources). But we want to use CircleCI to make sure that nobody breaks our monitoring pipeline by pushing an invalid config file.

Prometheus has a nice utility called [promtool](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#syntax-checking-rules) which can be used to check that a config/rules file is valid.  But to use it, we need to build it ourselves.

This image is just alpine linux with the `promtool` binary, and nothing else.

## About this repo

This repo just tracks changes to the Dockerfile.  The built image can be found at https://quay.io/mettle/promtool/

## Usage

### Using `docker run`

Check a prometheus config file:

```
docker run \
  -v /path/to/local/prometheus/configs:/tmp \
  mettle/promtool:1.0 \
  check config /tmp/prometheus.yml
```

Check a prometheus rules file

```
docker run \
  -v /path/to/local/prometheus/configs:/tmp \
  mettle/promtool:1.0 \
  check rules /tmp/prometheus.rules.yml
```
