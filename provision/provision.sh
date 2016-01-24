#!/usr/bin/env bash
sudo apt-get install software-properties-common
apt-get update
apt-get install ansible -y

cd `dirname $0`
if [ ! -f playbook.yml ]; then
    cd /vagrant/provision/
    echo $0
fi

PYTHONUNBUFFERED=1 ansible-playbook playbook.yaml --connection=local -i localhost,
