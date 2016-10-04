# adite/pro-gf
---
## PROMETHEUS + GRAFANA (PRO-GF)
![tescom](https://en.gravatar.com/userimage/96759029/aa4308f795041de37cc2fedf0d1071ca?size=128)


[![](https://images.microbadger.com/badges/image/adite/pro-gf.svg)](https://microbadger.com/images/adite/pro-gf "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/adite/pro-gf.svg)](https://microbadger.com/images/adite/pro-gf "Get your own version badge on microbadger.com")



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

## Environment
### Server Infomation
```shell
SERVER_IP   : YOUR_DB_SERVER1_IP_ADDRESS SERVER2_IP_ADDRESS SERVER3_IPADDRESS ...
SERVER_NAME : YOUR_DB_SERVER1_NAME1 SERVER2_NAME SERVER3_NAME ...
```
### Volume
```shell
VOLUME      : /usr/local/prometheus/data
```

## Port 
```shell
3000 : grafana
9090 : prometheus
```

## USAGE
```shell
$ sudo docker run --rm -i -p 3000:3000 \
  -e SERVER_IP="DB_SERVER1_IP DB_SERVER2_IP DB_SERVER3_IP" \
  -e SERVER_NAME="DB_SERVER1_NAME DB_SERVER2_NAME DB_SERVER3_NAME" \
  -v DOCKER_SERVER_LOCAL_DIRECTORY:/usr/local/prometheus/data   \
  -t adite/pro-gf
```

## Grafana connect
```shell
WEB BROWSER : http://{YOUR_HOST_IP_or_DOMAIN_NAME}:3000
ID / PW : admin / admin
```

## Grafana setting
Go to Data Sources and add settings for Prometheus
```shell
Name : Prometheus
Type : Prometheus
Uri : http://localhost:9090
```
![set](https://www.percona.com/blog/wp-content/uploads/2016/02/datasource.png)

Check out the dashboards and graphs. You can select host name.
![check](https://www.percona.com/blog/wp-content/uploads/2016/02/Screen-Shot-2016-02-28-at-23.51.55.png)


refs. https://www.percona.com/blog/2016/02/29/graphing-mysql-performance-with-prometheus-and-grafana/
