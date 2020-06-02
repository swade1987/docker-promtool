# promtool

Minimal docker image for running the [promtool](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#syntax-checking-rules) utility for validating prometheus config files.

## Why?

We currently keep all prometheus config files under source control at (https://github.com/eeveebank/monitoring-resources). 

We want to use CircleCI to make sure that nobody breaks our monitoring pipeline by pushing an invalid config file.

Prometheus has a nice utility called promtool which can be used to check that a config/rules file is valid, but to use it, we need to build it ourselves.