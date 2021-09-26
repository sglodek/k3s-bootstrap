#!/bin/bash

### Configure Consul ###
echo 'server = true' >> /etc/consul.d/consul.hcl
echo 'bootstrap_expect = 3' >> /etc/consul.d/consul.hcl
echo 'retry_join = ["provider=aws tag_key=role tag_value=consul-server"]' >> /etc/consul.d/consul.hcl
systemctl start consul
systemctl enable consul