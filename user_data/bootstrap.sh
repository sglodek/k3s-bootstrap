#!/bin/bash

### Install Consul ###
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt update && apt install consul
echo 'retry_join = ["provider=aws tag_key=role tag_value=consul_server"]' >> /etc/consul.d/consul.hcl
systemctl start consul
systemctl enable consul

### Configure systemd-resolved to use Consul ###
iptables -t nat -A OUTPUT -d localhost -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600
iptables -t nat -A OUTPUT -d localhost -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600

echo 'DNS=127.0.0.1' >> /etc/systemd/resolved.conf
echo 'Domains=~consul' >> /etc/systemd/resolved.conf
systemctl restart systemd-resolved.service

### Install Role Specific Features ###
git clone https://github.com/sglodek/k3s-bootstrap.git
cd k3s-bootstrap/user_data
apt install awscli
INSTANCE_ID=$(ec2metadata --instance-id)
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
ROLE=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=role" --region=$REGION --output=text | cut -f5)

source roles/$ROLE.sh