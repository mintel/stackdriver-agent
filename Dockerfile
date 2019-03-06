from debian:9-slim

LABEL org.label-schema.vcs-url="https://github.com/mintel/stackdriver-agent" \
      org.label-schema.vendor=mintel \
      org.label-schema.name=stackdriver-agent

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl gnupg2 && \
    echo "deb http://packages.cloud.google.com/apt google-cloud-monitoring-stretch main" | tee /etc/apt/sources.list.d/google-cloud-monitoring.list && \
    curl --silent https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y stackdriver-agent libhiredis-dev libpq-dev

COPY run-agent.sh /usr/bin/run-agent.sh
COPY configurator /opt/configurator
COPY collectd.conf /etc/stackdriver/collectd.conf

CMD ["run-agent.sh"]

