FROM ubuntu:16.04
RUN apt-get update \
    &&  apt-get install -y curl apache2  \
    && curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.6.1-amd64.deb \
    && dpkg -i filebeat-6.6.1-amd64.deb 
COPY filebeat.yml /etc/filebeat/
COPY ./do_work.sh /root/do_work.sh
USER root
RUN chmod 700 /etc/filebeat/filebeat.yml
RUN filebeat modules enable apache2
ENTRYPOINT /root/do_work.sh
