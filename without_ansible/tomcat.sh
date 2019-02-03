#!/bin/bash
hostname=`hostname`
echo Installing openjdk
yum install -y wget java-1.8.0-openjdk 1>/dev/null 2>/dev/null && echo Java installed
echo Getting tomcat
wget -c http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz 1>/dev/null 2>/dev/null &&  echo Tomcat downloaded
echo Configuring tomcat

if [ ! -e /opt/module3/apache-tomcat-8.5.37 ]; then

  mkdir /opt/module3
  chmod 744 /opt/module3
  cp apache-tomcat-8.5.37.tar.gz /opt/module3/
  cd /opt/module3/
  tar -xf apache-tomcat-8.5.37.tar.gz
  mkdir /opt/module3/apache-tomcat-8.5.37/webapps/testlb
fi

  echo Creating context
  if [ $hostname == 'tomcat1' ]; then
    echo 'Shrek is life' > /opt/module3/apache-tomcat-8.5.37/webapps/testlb/index.html
  else
    echo 'Shrek is love' > /opt/module3/apache-tomcat-8.5.37/webapps/testlb/index.html
  fi
  echo Chowning tomcat folder
  sudo chown -R vagrant:vagrant /opt

echo Starting tomcat
nohup /opt/module3/apache-tomcat-8.5.37/bin/catalina.sh start &
echo Done
