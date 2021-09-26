#!/bin/bash

### Configure Consul ###
echo 'retry_join = ["provider=aws tag_key=role tag_value=consul_server"]' >> /etc/consul.d/consul.hcl
systemctl start consul
systemctl enable consul

### Install k3s ###
#echo 'server = true' >> /etc/rancher/k3s/config.yaml
curl -sfL https://get.k3s.io | K3S_TOKEN="123" K3S_URL=https://k3s-server.service.consul:6443 sh -