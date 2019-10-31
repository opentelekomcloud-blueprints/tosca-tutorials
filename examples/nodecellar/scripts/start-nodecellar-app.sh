#!/bin/bash


echo "Start nodecellar..." 

source ~/nodecellar_env.sh

cd ~/nodecellar/nodecellar-master

# Terraform: Starting commands with screen or nohup are not kept running.
# https://github.com/hashicorp/terraform/issues/6229
sudo -E forever start -o out.log -e err.log server.js