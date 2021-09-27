#!/bin/bash

### Configure Consul ###
IPV4_ADDR=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo "bind_addr = \"$IPV4_ADDR\"" >> /etc/consul.d/consul.hcl
systemctl restart consul

### Install k3s ###
curl -sfL https://get.k3s.io | K3S_TOKEN="123" K3S_URL="https://k3s-server.consul.service:6443" INSTALL_K3S_EXEC="agent" sh -
