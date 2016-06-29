# adite/pro-gf
---
## PROMETHEUS + GRAFANA (PRO-GF)
![tescom](https://en.gravatar.com/userimage/96759029/aa4308f795041de37cc2fedf0d1071ca?size=128)

## Install exporter(agent) on client
```shell
$ wget https://github.com/prometheus/node_exporter/releases/download/0.12.0rc3/node_exporter-0.12.0rc3.linux-amd64.tar.gz
$ wget https://github.com/prometheus/mysqld_exporter/releases/download/0.7.1/mysqld_exporter-0.7.1.linux-amd64.tar.gz
$ mkdir /usr/local/prometheus_exporters
$ tar zxf node_exporter-0.12.0rc3.linux-amd64.tar.gz -C /usr/local/prometheus_exporters
$ tar zxf mysqld_exporter-0.7.1.linux-amd64.tar.gz -C /usr/local/prometheus_exporters
```

## Create mysql user and config file on client
### Create DB user
```shell
mysql> GRANT REPLICATION CLIENT, PROCESS ON *.* TO '{USER_NAME}'@'localhost' identified by '{YOUR_PASSWORD}';
mysql> GRANT SELECT ON performance_schema.* TO '{USER_NAME}'@'localhost';
```

### Create config file
```shell
$ cd /usr/local/prometheus_exporters
$ cat << EOF > .my.cnf
[client]
user={YOUR_MYSQL_USER}
password={YOUR_MYSQL_USER_PASSWORD}
EOF
```

## Run exporter on client
```shell
$ cd /usr/local/prometheus_exporters
$ ./node_exporter &
$ ./mysqld_exporter -config.my-cnf=".my.cnf" &
```

## Volume 
```shell
Prometheus home : /usr/local/prometheus
Grafana home : /var/lib/grafana
Grafana log : /var/log/grafana
```

## Port 
```shell
3000 : grafana
9090 : prometheus
```

## USAGE
```shell
$ sudo docker run --rm -i -p 3000:3000 -v {LOCAL_SHARE_DIRECTORY}:/usr/local/prometheus -t adite/pro-gf
```
