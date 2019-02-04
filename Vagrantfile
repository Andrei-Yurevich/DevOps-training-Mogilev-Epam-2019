require 'fileutils'
# - Ебанёт?
# - Не должно.
$tomcats_count = 3
text = File.read("./roles/httpd/templates/workers.properties.j2")
replace = text.gsub(/.*set.*/, "{% set tomcats_count = #$tomcats_count %}")
File.open("./roles/httpd/templates/workers.properties.j2", "w") {|file| file.puts replace}

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

  (1..$tomcats_count).each do |i|
    config.vm.define "tomcat#{i}" do |tomcat|
      tomcat.vm.box = "centos/7"
      tomcat.vm.network :private_network, ip: "192.168.0.#{1+i}"
      tomcat.vm.hostname = "tomcat#{i}"
      tomcat.vm.provision "ansible" do |ansible|
        ansible.playbook = "tomcat.yml"
        ansible.verbose = true
      end
    end
  end

end
