#!/bin/bash

for addr in $SERVER_IP
do
cat << EOF

global:
  scrape_interval:     5s
  evaluation_interval: 5s
scrape_configs:
  - job_name: linux
    target_groups:
      - targets: ['${addr}:9100']
        labels:
          alias: DB_${addr}
  - job_name: mysql
    target_groups:
      - targets: ['${addr}:9104']
        labels:
          alias: DB_${addr}

EOF
done
