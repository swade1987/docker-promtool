ARG PROMETHEUS_VERSION="Unknown"

FROM prom/prometheus:${PROMETHEUS_VERSION}
ENTRYPOINT ["/bin/promtool"]