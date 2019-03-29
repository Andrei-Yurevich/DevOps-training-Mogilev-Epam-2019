install_packages = ['yum-utils', \
                    'device-mapper-persistent-data', \
                    'curl', \
                    'lvm2',\
                    'git',\
                    'zip',\
                    'nmap']

# add docker repo
execute 'yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo'

# install dependencies
package install_packages do
  action :install
end

# update system
execute 'yum update -y'

docker_packages = ['docker-ce', 'docker-ce-cli', 'containerd.io']

# install docker packages
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


docker_image node['module10']['image'] do
  tag node['module10']['tag']
  action :pull
end

#green
check_green = docker_container 'module10_green' do
  repo node['module10']['repo']
  tag node['module10']['tag']
  port node['module10']['port_green']
  only_if 'nmap -p 8080 localhost | grep open'
end

#check_green
ruby_block "check_green" do
  block do
     require 'chef/mixin/shell_out'
     Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
     sleep(20)
     command = 'curl http://localhost:8081/test/'
     command_out = shell_out(command)
     raise "not work" if !command_out.stdout.include? node['module10']['tag']
  end
  only_if { check_green.updated_by_last_action? }
end

#remove blue
execute 'blue' do
  command 'docker stop module10_blue && docker rm module10_blue'
  only_if { check_green.updated_by_last_action? }
end

#blue
check_blue = docker_container 'module10_blue' do
  repo node['module10']['repo']
  tag node['module10']['tag']
  port node['module10']['port']
  only_if 'nmap -p 8081 localhost | grep open'
  not_if { check_green.updated_by_last_action? }
end

#check_content_blue
ruby_block "check_blue" do
  block do
     require 'chef/mixin/shell_out'
     Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
     sleep(20)
     command = 'curl http://localhost:8080/test/'
     command_out = shell_out(command)
     raise "not work" if !command_out.stdout.include? node['module10']['tag']
  end
  only_if { check_blue.updated_by_last_action? }
end

#remove green
execute 'green' do
  command 'docker stop module10_green && docker rm module10_green'
  only_if { check_blue.updated_by_last_action? }
end

#first time blue
docker_container 'module10_blue' do
  repo node['module10']['repo']
  tag node['module10']['tag']
  port node['module10']['port']
  only_if 'nmap -p 8080 localhost | grep closed'
  only_if 'nmap -p 8081 localhost | grep closed'
end
