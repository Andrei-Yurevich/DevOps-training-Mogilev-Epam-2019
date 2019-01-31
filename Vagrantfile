Vagrant.configure("2") do |config|

  config.vm.define "httpd_vm" do |httpd_vm|
    httpd_vm.vm.box = "centos/7"
    httpd_vm.vm.network :private_network, ip: "192.168.0.1"
    httpd_vm.vm.network :forwarded_port, guest: 80, host: 8080
    httpd_vm.vm.hostname = "httpd.server"
    httpd_vm.vm.provision "ansible" do |ansible|
      ansible.playbook = "httpd_vm.yml"
      ansible.verbose = true
    end
 
  end

  config.vm.define "tomcat1" do |tomcat1|
    tomcat1.vm.box = "centos/7"
    tomcat1.vm.network :private_network, ip: "192.168.0.2"
    tomcat1.vm.hostname = "tomcat1"
    tomcat1.vm.provision "ansible" do |ansible|
      ansible.playbook = "tomcat.yml"
      ansible.verbose = true
    end
  end

  config.vm.define "tomcat2" do |tomcat2|
    tomcat2.vm.box = "centos/7"
    tomcat2.vm.network :private_network, ip: "192.168.0.3"
    tomcat2.vm.hostname = "tomcat2"
    tomcat2.vm.provision "ansible" do |ansible|
      ansible.playbook = "tomcat.yml"
      ansible.verbose = true
    end
  end

end
