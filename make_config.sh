#!/bin/bash

name=1
for addr in $SERVER_IP
do
cat << EOF > /usr/local/prometheus/db${name}.yml

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
name=`echo $name+1|bc`
done
