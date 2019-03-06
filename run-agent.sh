#!/bin/bash

# Copyright (C) 2016 wikiwi.io
#
# This software may be modified and distributed under the terms
# of the MIT license. See the LICENSE file for details.

PID_FILE=/var/run/stackdriver-agent.pid

set -eo pipefail

for f in /opt/configurator/*.sh; do source $f; done

stopDaemon() {
  service stackdriver-agent stop
  kill -9 ${LOG_PID}
}

service stackdriver-agent start
trap stopDaemon SIGINT SIGTERM
touch /var/log/collectd.log
tail /var/log/collectd.log -f &
LOG_PID=$!

# echo Waiting for collectd daemon to start
while [ ! -f "${PID_FILE}" ] ; do
  sleep 1;
done

# Waiting for collectd daemon to stop
while [ -f "${PID_FILE}" ] ; do
  sleep 1;
done

