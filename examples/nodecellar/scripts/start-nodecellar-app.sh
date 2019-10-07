#!/bin/bash


echo "Start nodecellar..." 

source ~/nodecellar_env.sh

cd ~/nodecellar/nodecellar-master

sudo -E forever start -o out.log -e err.log server.js