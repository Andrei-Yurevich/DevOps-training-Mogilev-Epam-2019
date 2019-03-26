#!/bin/bash
sudo iptables -t mangle -A POSTROUTING -j TTL --ttl-set 65
pubkey=/home/vagrant/.ssh/id_rsa.pub
private_key=/home/vagrant/.ssh/id_rsa

if [ ! -f ./chefdk_3.8.14-1_amd64.deb ]; then
  wget -c https://packages.chef.io/files/stable/chefdk/3.8.14/ubuntu/14.04/chefdk_3.8.14-1_amd64.deb 2>/dev/null
  echo 'Allah loves patience (3:146)'

else
  echo 'Cheefdk already downloaded'
fi

if [ !  -f /usr/bin/chef ]; then 
  sudo dpkg -i chefdk_3.8.14-1_amd64.deb
else
  echo Cheefdk already installed
fi

echo  Add string to /etc/hosts only if string not exist
grep 'node1' /etc/hosts 1>/dev/null

if [[ $? -eq 1 ]]; then
  sudo bash -c 'echo 10.0.0.11 node1 >> /etc/hosts '
  echo /etc/hosts changed successfully
fi

echo Quiet key generating
if [ ! -f $private_key ] && [ ! -f $pubkey ]; then
  sudo -u vagrant ssh-keygen -t rsa -N "" -b 3072 -f $private_key 1>/dev/null
  if [ $? -eq 0 ]; then
    echo Ssh keys exists
  fi
fi

echo "vagrant:vagrant" | sudo chpasswd && echo Password changed

sudo sed 's/PasswordAuthentication\ no/PasswordAuthentication yes/g' -i /etc/ssh/sshd_config && echo Ssh configurtion changed.

sudo service ssh restart 1>/dev/null 2>/dev/null && echo Ssh server restarted

if [ ! -d module9/cookbooks ]; then
  sudo su vagrant -c 'mkdir -p module9/cookbooks'
  cd module9
  sudo su vagrant -c 'chef generate cookbook cookbooks/docker_install'
  echo -e "https://10.0.0.254:443/\nvagrant\n"|sudo su vagrant -c 'knife configure initial'
fi
