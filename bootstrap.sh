#!/bin/bash

AWS_PROFILE=$1
WHITELISTED_IP=$2

terraform1 apply -auto-approve -var='asg_count={"consul-server":3,"k3s-worker":0,"k3s-server":0}' -var="aws_profile=${AWS_PROFILE}" -var="whitelisted_ip=${WHITELISTED_IP}"
sleep 60
terraform1 apply -auto-approve -var='asg_count={"consul-server":3,"k3s-worker":0,"k3s-server":1}' -var='k3s_bootstrap=true' -var="aws_profile=${AWS_PROFILE}" -var="whitelisted_ip=${WHITELISTED_IP}"
sleep 60
terraform1 apply -auto-approve -var='asg_count={"consul-server":3,"k3s-worker":0,"k3s-server":3}' -var="aws_profile=${AWS_PROFILE}" -var="whitelisted_ip=${WHITELISTED_IP}"
sleep 60
terraform1 apply -auto-approve -var='asg_count={"consul-server":3,"k3s-worker":3,"k3s-server":3}' -var="aws_profile=${AWS_PROFILE}" -var="whitelisted_ip=${WHITELISTED_IP}"