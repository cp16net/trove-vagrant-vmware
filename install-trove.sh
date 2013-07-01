#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y --force-yes git-core

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

# create user trove
useradd trove -d /home/trove -s /bin/bash -m
echo trove:trove | chpasswd
sed -i '/^%sudo/a\trove ALL=(ALL) NOPASSWD:ALL' /etc/sudoers
#sed -i '$a\cd /home/trove/trove-integration/scripts' /home/trove/.bashrc

chown trove /opt/stack

# Install Django manually, as pip is acting a little slow
pushd /tmp
    wget http://pypi.python.org/packages/source/D/Django/Django-1.5.1.tar.gz#md5=7465f6383264ba167a9a031d6b058bff -O Django.tgz
    tar xzf Django.tgz
    pushd Django-1.5.1
        python setup.py install
    popd
popd

echo Installed.
