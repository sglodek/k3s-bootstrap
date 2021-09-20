#!/bin/bash

### Configure Consul ###
echo 'retry_join = ["provider=aws tag_key=role tag_value=consul_server"]' >> /etc/consul.d/consul.hcl
systemctl start consul
systemctl enable consul