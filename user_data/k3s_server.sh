#!/bin/bash

curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update && apt-get install consul
echo 'retry_join = ["provider=aws tag_key=Role tag_value=consul_server"]' >> /etc/consul.d/consul.hcl
systemctl start consul
systemctl enable consul

iptables -t nat -A OUTPUT -d localhost -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600
iptables -t nat -A OUTPUT -d localhost -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600

echo 'DNS=127.0.0.1' >> /etc/systemd/resolved.conf
echo 'Domains=~consul' >> /etc/systemd/resolved.conf
systemctl restart systemd-resolved.service