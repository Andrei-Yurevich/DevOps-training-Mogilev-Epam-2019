#!/bin/bash

#if [ ! -f ./chefdk_3.8.14-1_amd64.deb ]; then
#  wget -c https://packages.chef.io/files/stable/chef-server/12.19.31/ubuntu/14.04/chef-server-core_12.19.31-1_amd64.deb 2>/dev/null
#else
#  echo 'Cheef server already downloaded'
#fi

if [ ! -f /usr/bin/chef-server-ctl ]; then
  dpkg -i /vagrant/sources/chef-server-core_12.19.31-1_amd64.deb
  wget -c https://packages.chef.io/files/stable/chefdk/3.8.14/ubuntu/14.04/chefdk_3.8.14-1_amd64.deb 2>/dev/null
  dpkg -i chefdk_3.8.14-1_amd64.deb
  chef-server-ctl install chef-manage
  chef-server-ctl reconfigure
  chef-manage-ctl reconfigure --accept-license
  chef-server-ctl org-create epam "epam ltd" --filename /root/.chef/epam-validator.pem
  chef-server-ctl user-create vagrant vagrant vagrantovich vagrant@localhost.domain 'vagrant'
  chef-server-ctl org-user-add epam vagrant --admin
  #knife configure
  sudo knife bootstrap 10.0.0.11 -N node1 -x vagrant -P vagrant --sudo --node-ssl-verify-mode none
  

else
  echo Cheef server already installed
fi
