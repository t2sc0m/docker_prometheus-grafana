#!/bin/bash

ipcnt=0
namecnt=0

# Create array
for i in $(echo $SERVER_IP)
do
    IP[$ipcnt]=$i
    ipcnt=$(echo $ipcnt+1|bc)
done

for i in $(echo $SERVER_NAME)
do
    NAME[$namecnt]=$i
    namecnt=$(echo $namecnt+1|bc)
done

# Check server IP/NAME count
IPLEN=$(echo ${#IP[@]}-1|bc)
NAMELEN=$(echo ${#NAME[@]}-1|bc)

echo $IPLEN
echo $NAMELEN

if [ $IPLEN==$NAMELEN ]
then
#    echo "No Problem IP count == NAME count"
    LEN=${IPLEN}
else
    echo "ERR!! IP count != NAME count"
    LEN=0
fi

# Create prometheus.yml
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
      - targets: ['${IP[$i]}:9100']
        labels:
          alias: ${NAME[$i]}

EOF
done

cat << EOF >> ./prometheus.yml

  - job_name: mysql
    target_groups:
EOF

for i in $(seq 0 $LEN)
do
cat << EOF >> ./prometheus.yml
      - targets: ['${IP[$i]}:9104']
        labels:
          alias: ${NAME[$i]}

EOF
done
