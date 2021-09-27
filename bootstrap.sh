#!/bin/bash

terraform1 apply -auto-approve -var='asg_count={"consul-server":3,"k3s-worker":0,"k3s-server":0}'
sleep 60
terraform1 apply -auto-approve -var='asg_count={"consul-server":3,"k3s-worker":0,"k3s-server":1}' -var='k3s_bootstrap=true'
sleep 60
terraform1 apply -auto-approve -var='asg_count={"consul-server":3,"k3s-worker":0,"k3s-server":3}'
sleep 60
terraform1 apply -auto-approve -var='asg_count={"consul-server":3,"k3s-worker":3,"k3s-server":3}'