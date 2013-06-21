#!/bin/bash

apt-get update -qq
apt-get install -qq build-essential git-core libxml2-dev libxslt1-dev

# Go get the code
mkdir /opt/stack
pushd /opt/stack
    git clone git://github.com/openstack/trove.git reddwarf
    git clone git://github.com/openstack/trove-integration.git trove-integration
    git clone git://github.com/openstack/python-troveclient.git python-reddwarfclient
popd

# Create the user ubuntu
useradd ubuntu -d /home/ubuntu -s /bin/bash -m
echo ubuntu:ubuntu | chpasswd

# Change where ubuntu starts at login
#sed -i '$a\cd /home/ubuntu/trove-integration/scripts' /home/ubuntu/.bashrc 
ln -s /opt/stack/trove-integration /home/ubuntu/trove-integration

# Give ubuntu root nopasswd powers
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
