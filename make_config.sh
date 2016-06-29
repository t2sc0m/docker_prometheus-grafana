#!/bin/bash

for addr in $SERVER_IP
do
name=`echo $addr|awk -F. '{print $4}'`
cat << EOF

global:
  scrape_interval:     5s
  evaluation_interval: 5s
scrape_configs:
  - job_name: linux
    target_groups:
      - targets: ['${addr}:9100']
        labels:
          alias: DB${name}
  - job_name: mysql
    target_groups:
      - targets: ['${addr}:9104']
        labels:
          alias: DB${name}

EOF
done
