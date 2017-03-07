#!/bin/bash

/bin/rm -rf /var/lib/grafana/dashboards && \
/bin/tar xzf Gdashboard.tgz -C /var/lib/grafana/ && \
/bin/rm -rf /tmp/Gdashboard.tgz

/etc/init.d/grafana-server start
/make_config.sh 
/usr/local/prometheus/prometheus 
