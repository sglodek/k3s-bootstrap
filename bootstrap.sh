terraform1 plan -var='asg_count={"consul-server":3,"k3s-worker":0,"k3s-server":0}'
terraform1 plan -var='asg_count={"consul-server":3,"k3s-worker":0,"k3s-server":1}' -var='k3s_bootstrap=true'
terraform1 plan -var='asg_count={"consul-server":3,"k3s-worker":0,"k3s-server":3}'
terraform1 plan -var='asg_count={"consul-server":3,"k3s-worker":3,"k3s-server":3}'