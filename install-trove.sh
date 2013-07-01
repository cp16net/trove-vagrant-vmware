#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y --force-yes git-core

# Code should be shared at /trove.
# If it isn't, go get it.
# Get the code. If /trove isn't populated, go get the pieces.
mkdir -p /opt/stack
SHARE=/trove
mkdir -p $SHARE
pushd $SHARE
    for REPO in python-troveclient trove trove-integration; do
        if [ ! -d "$SHARE/$REPO" ]; then
            git clone git://github.com/openstack/$REPO.git
        fi
        ln -s $SHARE/$REPO /opt/stack/$REPO
    done
popd

# create user trove
useradd trove -d /home/trove -s /bin/bash -m
echo trove:trove | chpasswd
sed -i '/^%sudo/a\trove ALL=(ALL) NOPASSWD:ALL' /etc/sudoers
ln -s /opt/stack/trove-integration /home/trove/trove-integration
sed -i '$a\cd /home/trove/trove-integration/scripts' /home/trove/.bashrc

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
