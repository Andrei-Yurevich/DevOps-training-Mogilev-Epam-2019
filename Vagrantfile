Vagrant.configure("2") do |config|

  config.vm.define "vm1" do |vm1|
    vm1.vm.box = "centos/7"
    vm1.vm.network :private_network, ip: "192.168.0.1"
    vm1.vm.hostname = "VM1"
    #vm1.vm.network "forwarded_port", guest: 22, host: 1111

    vm1.vm.provision "ansible" do |ansible|
      ansible.playbook = "vm1.yml"
      ansible.verbose = true
    end
    vm1.vm.provision "shell", inline: "cat /root/my_project/file.txt"
 
  end

  config.vm.define "vm2" do |vm2|
    vm2.vm.box = "centos/7"
    vm2.vm.network :private_network, ip: "192.168.0.2"
    vm2.vm.hostname = "VM2"
    #vm2.vm.network "forwarded_port", guest: 22, host: 2222
    vm2.vm.provision "ansible" do |ansible|
      ansible.playbook = "vm2.yml"
      ansible.verbose = true
    end
  end


end
