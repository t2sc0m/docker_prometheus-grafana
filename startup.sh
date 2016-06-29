#!/bin/bash

/etc/init.d/grafana-server start
/make_config.sh
/usr/local/prometheus/prometheus
