#!/bin/bash


APPLICATION_URL="https://github.com/cloudify-cosmo/nodecellar/archive/master.tar.gz"
AFTER_SLASH=${APPLICATION_URL##*/}
NODECELLAR_ARCHIVE_NAME=${AFTER_SLASH%%\?*}

NODECELLAR_ROOT_PATH=~/nodecellar

echo "mkdir -p ${NODECELLAR_ROOT_PATH}"
mkdir -p ${NODECELLAR_ROOT_PATH}

echo "cd ${NODECELLAR_ROOT_PATH}" 
cd ${NODECELLAR_ROOT_PATH}

echo "wget  –quiet ${APPLICATION_URL} -O - | tar -xz"
sudo wget  –quiet ${APPLICATION_URL} -O - | sudo tar -xz

echo "cd nodecellar-master"
cd nodecellar-master

echo "npm -y install"
sudo npm -y install


echo "BEGIN set mongo url"
sudo echo "#!/bin/bash" > ~/nodecellar_env.sh
sudo echo "export NODECELLAR_PORT=$NODECELLAR_PORT" >> ~/nodecellar_env.sh
sudo echo "export MONGO_HOST=$DB_IP" >> ~/nodecellar_env.sh
sudo echo "export MONGO_PORT=$DB_PORT" >> ~/nodecellar_env.sh
echo "END set mongo url"