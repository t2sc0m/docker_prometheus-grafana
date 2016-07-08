#!/bin/bash

name=1

cat << EOF > prometheus.yml

global:
  scrape_interval:     5s
  evaluation_interval: 5s
scrape_configs:
  - job_name: linux
    target_groups:
EOF

for addr in $SERVER_IP
do
cat << EOF >> prometheus.yml
      - targets: ['${addr}:9100']
        labels:
          alias: DB${name}

EOF
name=`echo $name+1|bc`
done

cat << EOF >> prometheus.yml

  - job_name: mysql
    target_groups:
EOF

name=1

for addr in $SERVER_IP
do
cat << EOF >> prometheus.yml
      - targets: ['${addr}:9104']
        labels:
          alias: DB${name}

EOF
name=`echo $name+1|bc`
done
