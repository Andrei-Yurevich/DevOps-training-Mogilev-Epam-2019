#!/bin/bash

right_lib_sum=fa98ad5627866a7f42f332d73f0dbfe7
sudo iptables -t mangle -A POSTROUTING -j TTL --ttl-set 65
echo Installing httpd.
yum install -y httpd 1>/dev/null 2>/dev/null

if [ $? -eq 0 ]; then
  echo HTTPd installed.
else
  Git is not installed.
  exit 1
fi

if [ -f /etc/httpd/modules/mod_jk.so ]; then
  host_lib_sum=`md5sum /etc/httpd/modules/mod_jk.so`

  if [ "$host_lib_sum" == "$right_lib_sum" ]; then
    echo Right mod_jk.so already exist
  else
    rm /etc/httpd/modules/mod_jk.so
    cp /vagrant/sources/mod_jk.so /etc/httpd/modules/ && echo mod_jk.so copied.
    chmod 755 /etc/httpd/modules/mod_jk.so && echo mod_jk.so chmoded.
  fi

else
  cp /vagrant/sources/mod_jk.so /etc/httpd/modules/
  chmod 755 /etc/httpd/modules/mod_jk.so
fi

cp /vagrant/sources/workers.properties /etc/httpd/conf/ && echo workers.properties copied
chmod 644 /etc/httpd/conf/workers.properties && echo workers.properties chmoded

##### It's more readable then \n
echo 'LoadModule jk_module modules/mod_jk.so' >> /etc/httpd/conf/httpd.conf
echo 'JkWorkersFile conf/workers.properties' >> /etc/httpd/conf/httpd.conf
echo 'JkShmFile /tmp/shm' >> /etc/httpd/conf/httpd.conf
echo 'JkLogFile logs/mod_jk.log' >> /etc/httpd/conf/httpd.conf
echo 'JkLogLevel info' >> /etc/httpd/conf/httpd.conf
echo 'JkMount /testlb* balancer' >> /etc/httpd/conf/httpd.conf
echo httpd.conf edited
#####

systemctl enable httpd 2>&1 && systemctl start httpd
