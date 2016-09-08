#!/bin/bash

LEN=`echo ${#SERVER_NAME[@]}-1|bc`

cat << EOF > ./prometheus.yml

global:
  scrape_interval:     5s
  evaluation_interval: 5s
scrape_configs:
  - job_name: linux
    target_groups:
EOF

for i in $(seq 0 $LEN)
do
cat << EOF >> ./prometheus.yml
      - targets: ['${SERVER_IP[$i]}:9100']
        labels:
          alias: ${SERVER_NAME[$i]}

EOF
done

cat << EOF >> ./prometheus.yml

  - job_name: mysql
    target_groups:
EOF

for i in $(seq 0 $LEN)
do
cat << EOF >> ./prometheus.yml
      - targets: ['${SERVER_IP[$i]}:9104']
        labels:
          alias: ${SERVER_NAME[$i]}

EOF
done
