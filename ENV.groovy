import groovy.json.JsonSlurper 
def cmd = "knife environment list -F json -c /home/vagrant/chef-repo/.chef/knife.rb"
Process env = cmd.execute()
env.waitFor()
def envlist = new JsonSlurper().parseText(process.text)
return envlist.sort()
