#!/bin/bash

echo Updating apt and installing prerequisites.
export DEBIAN_FRONTEND=noninteractive
apt-get update -y -q
apt-get install -y -q git-core libxml2-dev libxslt1-dev


echo Linking Trove codebase.
SHARE=/trove
mkdir -p /opt/stack $SHARE
pushd $SHARE
    for REPO in python-troveclient trove trove-integration; do
        if [ ! -d "$SHARE/$REPO" ]; then
            git clone git://github.com/openstack/$REPO.git
        fi
        if [ ! -e "/opt/stack/$REPO" ]; then
            ln -s $SHARE/$REPO /opt/stack/$REPO
        fi
    done
popd


echo Creating user trove.
if [ ! -d /home/trove ]; then
    useradd trove -d /home/trove -s /bin/bash -m
    echo trove:trove | chpasswd
    sed -i '/^%sudo/a\trove ALL=(ALL) NOPASSWD:ALL' /etc/sudoers
    ln -s /opt/stack/trove-integration /home/trove/trove-integration
    sed -i '$a\cd /home/trove/trove-integration/scripts' /home/trove/.bashrc
    chown trove /opt/stack
fi


echo Installing Django manually.
if [ ! -e "/usr/local/lib/python2.7/dist-packages/django" ]; then
    pushd /tmp
        wget http://pypi.python.org/packages/source/D/Django/Django-1.5.1.tar.gz#md5=7465f6383264ba167a9a031d6b058bff -O Django.tgz -q
        tar xzf Django.tgz
        pushd Django-1.5.1
            python setup.py install > /dev/null 2>&1
        popd
        rm -rf Django*
    popd
fi


echo Creating fix-iptables.sh
FIXSH="fix-iptables.sh"
if [ ! -e "$FIXSH" ]; then
    pushd /opt/stack/trove-integration/scripts
        echo "#!/bin/bash" > $FIXSH
        echo "sudo iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE" >> $FIXSH
        chmod +x $FIXSH
    popd
fi


echo Installed.
