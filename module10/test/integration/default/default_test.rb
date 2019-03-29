describe file('/etc/docker/daemon.json') do
  it { should exist }
  its('content') { should match(/192.168.43.12:5000/) }
end

describe port.where { port >= 8080 && port <= 8081 } do
  it { should be_listening }
end

describe bash('docker ps') do
  its('stdout') { should match (/module10/) }
  its('stdout') { should match (/192.168.43.12:5000/) }
end
