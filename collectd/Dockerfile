FROM ubuntu:16.04

RUN apt -y update && apt -y install collectd && apt -y clean \
&& export PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
COPY ./collectd.conf /etc/collectd/collectd.conf

ENTRYPOINT [ "collectd", "-f" ]
