install_packages = ['yum-utils', \
                    'device-mapper-persistent-data', \
                    'curl', \
                    'lvm2',\
                    'git',\
                    'zip',\
                    'nmap']

# yum add repo
execute 'yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo'
# install docker's dependencies
package install_packages do
  action :install
end

# update add packages
execute 'yum update -y'

docker_packages = ['docker-ce', 'docker-ce-cli', 'containerd.io']

# install necessary packages

package docker_packages do
  action :install
end

# start and enable docker service
service 'docker' do
  action [:start, :enable]
end

# create docker registry
template '/etc/docker/deamon.json' do
source 'deamon.json.erb'
notifies :restart, 'service[docker]', :delayed

end

# pull tomcat
docker_image 'tomcat' do
  action :pull_if_missing
  tag '9.0.16-jre8'
end

# clone and checkout my repo
execute 'cd $HOME && if [ ! -d /root/DevOps-training-Mogilev-Epam-2019 ] ; then git clone https://github.com/Andrey1913/DevOps-training-Mogilev-Epam-2019; fi \
      && cd DevOps-training-Mogilev-Epam-2019 \
      && git checkout module4'

# build artifact

execute 'cd $HOME/DevOps-training-Mogilev-Epam-2019 && ./gradlew incr && ./gradlew build'

execute 'cp $HOME/DevOps-training-Mogilev-Epam-2019/build/libs/task4.war $HOME/'

# Run on 8081; green
run_green = docker_container 'green' do
  only_if 'nmap -p 8080 localhost | grep open'
  only_if 'nmap -p 8081 localhost | grep closed'
  repo 'tomcat'
  tag '9.0.16-jre8'
  port [ '8081:8080' ]
  action :run
  volumes [ '/root/:/opt/' ]
  command "bash -c 'cp /opt/task4.war /usr/local/tomcat/webapps/ && ./bin/catalina.sh run'"
end

execute 'save image and remove blue container' do
  command "curl --silent localhost:8080/task4/ |\
           egrep '.*[0-9]+\.[0-9]+\.[0-9]+'    |\
           sed 's/.*<p>//; s/<.*//'            |\
           xargs -i docker commit blue blue:{} &&\
           docker stop blue ; docker rm blue"
  only_if 'docker ps | grep blue' 
end

execute 'remove first_run' do
  command "curl --silent localhost:8080/task4/ |\
           egrep '.*[0-9]+\.[0-9]+\.[0-9]+'    |\
           sed 's/.*<p>//; s/<.*//'            |\
           xargs -i docker commit first_run first_run:{} &&
           docker stop first_run ; docker rm first_run"
  only_if 'docker ps | grep first_run'
end

# Run on 8080; blue
run_blue = docker_container 'blue' do
  not_if { run_green.updated_by_last_action? }
  only_if 'nmap -p 8081 localhost | grep open'
  only_if 'nmap -p 8080 localhost | grep closed'
  repo 'tomcat'
  tag '9.0.16-jre8'
  port [ '8080:8080' ]
  action :run
  volumes [ '/root/:/opt/' ]
  command "bash -c 'cp /opt/task4.war /usr/local/tomcat/webapps/ && ./bin/catalina.sh run'"
end

execute ' save image and remove green container' do
  command "curl --silent localhost:8081/task4/ |\
           egrep '.*[0-9]+\.[0-9]+\.[0-9]+'    |\
           sed 's/.*<p>//; s/<.*//'            |\
           xargs -i docker commit green green:{} && \
           docker stop green ; docker rm green;"

  only_if { run_blue.updated_by_last_action? }
end

# First run; run on blue port
first_run = docker_container 'first_run' do
  only_if 'nmap -p 8080 localhost | grep closed'
  only_if 'nmap -p 8081 localhost | grep closed'
  repo 'tomcat'
  tag '9.0.16-jre8'
  port [ '8080:8080' ]
  action :run
  network_mode 'host'
  volumes [ '/root/:/opt/' ]
  command "bash -c 'cp /opt/task4.war /usr/local/tomcat/webapps/ && ./bin/catalina.sh run'"
  end
