#
# Cookbook:: CentOS 7
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

install_packages = ['yum-utils', \
                    'device-mapper-persistent-data', \
                    'curl', \
                    'lvm2']

# yum add repo
execute 'yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo'

# install docker's dependencies
package install_packages do
  action :install
end

# update add packages
#execute 'yum update -y'

docker_packages = ['docker-ce', 'docker-ce-cli', 'containerd.io']

# install necessary packages
package docker_packages do
  action :install
end

# start and enable docker service
service 'docker' do
  action [:start, :enable]
end

# create docker template
template '/etc/docker/deamon.json' do
source 'deamon.json.erb'
notifies :restart, 'service[docker]', :delayed

end
