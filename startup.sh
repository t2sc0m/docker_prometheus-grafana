#!/bin/bash

/etc/init.d/grafana-server start
/make_config.sh 
cd /usr/local/prometheus
cat db1.yml >> prometheus.yml
/usr/local/prometheus/prometheus
