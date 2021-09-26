#!/bin/bash

### Find instance role ###
git clone https://github.com/sglodek/k3s-bootstrap.git
cd k3s-bootstrap/user_data
apt update && apt install -y awscli
INSTANCE_ID=$(ec2metadata --instance-id)
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
ROLE=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=role" --region=$REGION --output=text | cut -f5)

### Install Consul and generate service config ###
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt update && apt install -y consul

consul_template="configs/consul-service"
consul_template_str=$(cat "${consul_template}")
eval "echo \"${consul_template_str}\"" > /etc/consul.d/$ROLE.hcl

### Configure systemd-resolved to use Consul ###
iptables -t nat -A OUTPUT -d localhost -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600
iptables -t nat -A OUTPUT -d localhost -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600

echo 'DNS=127.0.0.1' >> /etc/systemd/resolved.conf
echo 'Domains=~consul' >> /etc/systemd/resolved.conf
systemctl restart systemd-resolved.service

### Install Role Specific Features ###
source roles/$ROLE.sh