#!/bin/bash

git clone https://github.com/sglodek/k3s-bootstrap.git
chmod 700 ./user_data/roles/base.sh
./user_data/roles/base.sh