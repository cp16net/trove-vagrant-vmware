#!/bin/bash

apt-get update -qq
apt-get install -qq build-essential git-core libxml2-dev libxslt1-dev

# Get the code
SHARE=/opt/stack
mkdir -p $SHARE
pushd $SHARE
    for REPO in python-troveclient trove trove-integration; do
        if [ ! -d "$SHARE/$REPO" ]; then
            git clone git://github.com/openstack/$REPO.git
        fi
    done
popd

# Create the user ubuntu
useradd ubuntu -d /home/ubuntu -s /bin/bash -m
echo ubuntu:ubuntu | chpasswd
ln -s $SHARE/trove-integration /home/ubuntu/trove-integration
sed -i '$a\cd /home/ubuntu/trove-integration/scripts' /home/ubuntu/.bashrc 
sed -i '/^%sudo/a\ubuntu ALL=(ALL) NOPASSWD:ALL' /etc/sudoers

# Fix the IPtables.
#iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE

# Install Django manually, as pip is acting a little slow
pushd /tmp
    wget http://pypi.python.org/packages/source/D/Django/Django-1.5.1.tar.gz#md5=7465f6383264ba167a9a031d6b058bff -O Django.tgz
    tar xzf Django.tgz
    pushd Django-1.5.1
        python setup.py install
    popd
popd

# Install and kick-start as ubuntu
sudo su - ubuntu -c "cd ~/trove-integration/scripts; ./redstack install && ./redstack kick-start mysql"

echo Installed.
