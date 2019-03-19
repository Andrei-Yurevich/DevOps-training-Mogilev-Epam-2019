#
# Cookbook:: kubernetes
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

install_packages = ['apt-transport-https', \
                    'ca-certificates', \
                    'curl', \
                    'gnupg-agent', \
                    'software-properties-common']

# yum update
execute 'apt update -y'

# install pgp key
execute 'add gpg key' do
  command 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -'
  action :run
end

# install docker's dependencies
package install_packages do
  action :install
end

execute 'add fingerprint' do
  command 'apt-key fingerprint 0EBFCD88'
  action :run
end

# add docker repo
execute 'add docker-ce repo' do
  command 'add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"'
  action :run
end

execute 'apt update -y'

docker_packages = ['docker-ce']

package docker_packages do
  action :install
end

template '/etc/docker/deamon.json' do

source 'deamon.json.erb'

end

# start and enable docker service
service 'docker' do
  action [:start, :enable]
end





