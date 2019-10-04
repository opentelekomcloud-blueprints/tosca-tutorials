#!/bin/bash


echo "node ~/nodecellar/nodecellar-master/server.js 2>&1 >/var/log/nodecellar.log &" 

source ~/nodecellar_env.sh

cd ~/nodecellar/

sudo forever start -o out.log -e err.log server.js

PID=$!

sudo echo "$PID" > ~/nodecellar/nodecellarpid.txt

echo "processus id :${PID}"