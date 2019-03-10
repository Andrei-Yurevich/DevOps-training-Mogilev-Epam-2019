FROM ubuntu:16.04

RUN apt -y update && apt -y install wget && apt -y clean

RUN wget -c https://dl.grafana.com/oss/release/grafana_5.4.2_amd64.deb && apt install -y adduser libfontconfig && dpkg -i grafana_5.4.2_amd64.deb

COPY influx.yml /usr/share/grafana/conf/provisioning/datasources/

COPY  ./dashboards/module7.json /usr/share/grafana/conf/provisioning/dashboards/

COPY  ./dashboards/sample.yaml /usr/share/grafana/conf/provisioning/dashboards

ENTRYPOINT grafana-server --homepath="/usr/share/grafana"
