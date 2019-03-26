log_level          :info
log_location       STDOUT
ssl_verify_mode    :verify_none
chef_server_url    "https://10.0.0.254/organizations/epam"
verify_api_client  false
validation_client_name "epam-validator"
validation_key         "/etc/chef/epam-validator.pem"
node_name              "node1"
cookbook_path "/vagrant/install_docker"
