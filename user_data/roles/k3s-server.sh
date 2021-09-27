#!/bin/bash

### Configure Consul ###
IPV4_ADDR=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo "bind_addr = \"$IPV4_ADDR\"" >> /etc/consul.d/consul.hcl
systemctl restart consul

### Install k3s ###
BOOTSTRAP=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=bootstrap" --region=$REGION --output=text | cut -f5)

if [ $BOOTSTRAP = true ]
then
    curl -sfL https://get.k3s.io | K3S_TOKEN="123" INSTALL_K3S_EXEC="server --cluster-init" sh -
else
    curl -sfL https://get.k3s.io | K3S_TOKEN="123" K3S_URL="https://k3s-server.consul.service:6443" INSTALL_K3S_EXEC="server" sh -
fi