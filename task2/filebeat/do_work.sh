#!/bin/bash
service apache2 start
curl localhost 1>/dev/null 2>/dev/null # to fill log file
sleep 80
/usr/share/filebeat/bin/filebeat -e -c /etc/filebeat/filebeat.yml -path.home /usr/share/filebeat -path.config /etc/filebeat -path.data /var/lib/filebeat -path.logs /var/log/filebeat
