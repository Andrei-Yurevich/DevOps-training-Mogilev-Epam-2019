#!/bin/bash
sudo iptables -t mangle -A POSTROUTING -j TTL --ttl-set 65
pubkey=/home/vagrant/.ssh/id_rsa.pub
private_key=/home/vagrant/.ssh/id_rsa
auth_key=/home/vagrant/.ssh/authorized_keys

echo Quiet key generating

if [ ! -e $private_key ] && [ ! -e $pubkey ]; then
  sudo -u vagrant ssh-keygen -t rsa -N "" -b 3072 -f $private_key 1>/dev/null
  if [ $? -eq 0 ]; then
    echo ssh keys created
  fi
fi

echo  Add string to /etc/hosts only if string not exist
grep 'vm1.local' /etc/hosts 1>/dev/null

if [[ $? -eq 1 ]]; then
      sudo bash -c 'echo 192.168.0.1 vm1.local >> /etc/hosts && echo /etc/hosts changed successfully'
fi

echo Installing sshpass
sudo yum install -y sshpass 1>/dev/null 2>/dev/null

echo Putting vm2 pub key to vm1
sudo -u vagrant sshpass -p "vagrant" ssh-copy-id -oStrictHostKeyChecking=no -i $pubkey vagrant@192.168.0.1 1>/dev/null 2>/dev/null

echo Getting pub key from vm1
vm1_key=`sudo -u vagrant ssh -oStrictHostKeyChecking=no 192.168.0.1 cat $pubkey`

grep 'vagrant@VM1' $auth_key

if [ $? -eq 1 ]; then
  echo $vm1_key >> $auth_key
fi
