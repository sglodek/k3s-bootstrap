#!/bin/bash

### Configure Consul ###
echo 'retry_join = ["provider=aws tag_key=role tag_value=consul_server"]' >> /etc/consul.d/consul.hcl
systemctl start consul
systemctl enable consul

### Install k3s ###
#echo 'server = true' >> /etc/rancher/k3s/config.yaml
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" sh -