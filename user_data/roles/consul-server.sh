#!/bin/bash

### Configure Consul ###
echo 'server = true' >> /etc/consul.d/consul.hcl
echo 'bootstrap_expect = 3' >> /etc/consul.d/consul.hcl
systemctl restart consul