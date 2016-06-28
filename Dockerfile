FROM adite/base
MAINTAINER tescom <tescom@atdt01410.com>

# Install packages
RUN apt-get update && \
    apt-get install -y libfontconfig wget adduser && \
    cd /tmp && \
    wget https://grafanarel.s3.amazonaws.com/builds/grafana_2.6.0_amd64.deb && \
    dpkg -i grafana_2.6.0_amd64.deb && \
    git clone https://github.com/percona/grafana-dashboards.git && \
    cp -r grafana-dashboards/dashboards /var/lib/grafana && \
    chown grafana:grafana /var/lib/grafana -R && \
    sed -i 's/step_input:""/step_input:c.target.step/; s/ HH:MM/ HH:mm/; s/,function(c)/,"templateSrv",function(c,g)/; s/expr:c.target.expr/expr:g.replace(c.target.expr,c.panel.scopedVars)/' /usr/share/grafana/public/app/plugins/datasource/prometheus/query_ctrl.js && \
    sed -i 's/h=a.interval/h=g.replace(a.interval, c.scopedVars)/' /usr/share/grafana/public/app/plugins/datasource/prometheus/datasource.js && \
    wget https://github.com/prometheus/prometheus/releases/download/0.17.0rc2/prometheus-0.17.0rc2.linux-amd64.tar.gz && \
    mkdir -p /usr/local/prometheus && \
    tar zxf prometheus-0.17.0rc2.linux-amd64.tar.gz -C /usr/local/prometheus --strip-components=1

# Add prometheus config file
ADD prometheus.yml /usr/local/prometheus/prometheus.yml

ADD startup.sh /startup.sh
RUN chmod 0755 /startup.sh

VOLUME ["/usr/local/prometheus"]
VOLUME ["/var/lib/grafana"]
VOLUME ["/var/log/grafana"]

EXPOSE 3000
EXPOSE 9090

WORKDIR /usr/local/prometheus
ENTRYPOINT ["/startup.sh"]
