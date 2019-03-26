#!/bin/bash
sudo iptables -t mangle -A POSTROUTING -j TTL --ttl-set 65
private_key=/home/vagrant/.ssh/id_rsa
pubkey=/home/vagrant/.ssh/id_rsa.pub
auth_key=/home/vagrant/.ssh/authorized_keys

echo Quiet key generating
if [ ! -e $private_key ] && [ ! -e $pubkey ]; then
  sudo -u vagrant ssh-keygen -t rsa -N "" -b 3072 -f $private_key 1>/dev/null
  if [ $? -eq 0 ]; then
    echo ssh keys created
  fi
fi

echo  Add string to /etc/hosts only if string not exist
grep 'cheefdk' /etc/hosts 1>/dev/null

if [[ $? -eq 1 ]]; then
      sudo bash -c 'echo 10.0.0.10 cheefdk >> /etc/hosts && echo /etc/hosts changed successfully'
fi

echo Installing sshpass
sudo apt install -y sshpass 1>/dev/null 2>/dev/null

echo Putting node1 pub key to cheefdk
sudo su vagrant -c 'sshpass -p "vagrant" ssh-copy-id -oStrictHostKeyChecking=no -i /home/vagrant/.ssh/id_rsa.pub vagrant@10.0.0.10'

echo Getting pub key from cheefdk
cheefdk_key=`sudo -u vagrant ssh -oStrictHostKeyChecking=no 10.0.0.10 cat $pubkey`
echo "vagrant:vagrant" | sudo chpasswd && echo Password change Password changedd 

grep 'vagrant@cheefdk' $auth_key

if [ $? -eq 1 ]; then
  echo $cheefdk_key >> $auth_key
fi

if [ ! -f /etc/chef ]; then
  echo Copying config files
  mkdir /etc/chef/
  cp /vagrant/sources/node/client.rb /etc/chef/
  cp /vagrant/sources/node/epam-validator.pem /etc/chef/
  cp /vagrant/sources/node/first-boot.json /etc/chef/
  curl -L https://omnitruck.chef.io/install.sh | sudo bash
fi

curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chef-workstation -c stable -v 0.2.41
