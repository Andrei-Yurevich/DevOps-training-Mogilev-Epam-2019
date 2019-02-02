#!/bin/bash
sudo iptables -t mangle -A POSTROUTING -j TTL --ttl-set 65
git_filder=/home/vagrant/task
pubkey=/home/vagrant/.ssh/id_rsa.pub
private_key=/home/vagrant/.ssh/id_rsa


echo Install git if not installed
sudo yum install -y git 1>/dev/null 2>/dev/null

if [ $? -eq 0 ]; then
  echo "Git installed"
fi

if [ ! -d $git_filder ]; then

  git clone  https://github.com/Andrey1913/DevOps-training-Mogilev-Epam-2019 $git_filder 1>/dev/null
  cd $git_filder
  git checkout module2+addition_task 1>/dev/null 2>/dev/null

  if [[ $? -eq 0 ]]; then
    echo Git checkouted successfully
  fi

fi

cat $git_filder/file.txt

echo  Add string to /etc/hosts only if string not exist
grep 'vm2.local' /etc/hosts 1>/dev/null

if [[ $? -eq 1 ]]; then
  sudo bash -c 'echo 192.168.0.2 vm2.local >> /etc/hosts '
  echo /etc/hosts changed successfully
fi

echo Quiet key generating 
if [ ! -f $private_key ] && [ ! -f $pubkey ]; then
  sudo -u vagrant ssh-keygen -t rsa -N "" -b 3072 -f $private_key 1>/dev/null 
  if [ $? -eq 0 ]; then
    echo Ssh keys exists
  fi
fi

echo "vagrant" | sudo passwd "vagrant" --stdin 1>/dev/null && echo Password changed

sudo sed 's/PasswordAuthentication\ no/PasswordAuthentication yes/g' -i /etc/ssh/sshd_config && echo Ssh configurtion changed.

sudo service sshd restart 1>/dev/null 2>/dev/null && echo Ssh server restarted

