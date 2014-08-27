#!/bin/bash

# Install variables
SHARE=${1:-/trove}
TROVE_VM_ENV=${2:-public}

APT_PACKAGES="git-core libxml2-dev libxslt1-dev python-pexpect apache2 bc debhelper curl"
TROVE_REPOS="python-troveclient trove trove-integration"

# Install functions
function update_sources() {
    SOURCES_UPDATED="/home/vagrant/.sources-updated"
    if [ ! -e "$SOURCES_UPDATED" ]; then
        SOURCES=/etc/apt/sources.list

        echo -e "deb mirror://mirrors.ubuntu.com/mirrors.txt precise main restricted universe multiverse
    deb mirror://mirrors.ubuntu.com/mirrors.txt precise-updates main restricted universe multiverse
    deb mirror://mirrors.ubuntu.com/mirrors.txt precise-backports main restricted universe multiverse
    deb mirror://mirrors.ubuntu.com/mirrors.txt precise-security main restricted universe multiverse
    \n$(cat $SOURCES)" > $SOURCES

        touch "$SOURCES_UPDATED"
    fi
}

function install_apt_repos() {
    echo Updating apt and installing prerequisites.
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y -q
    apt-get install -y -q $APT_PACKAGES
}

function install_trove_repos() {
    echo Trove shared directory is $SHARE
    echo Linking Trove codebase.
    mkdir -p /opt/stack $SHARE
    for REPO in $TROVE_REPOS; do
        if [ ! -d "$SHARE/$REPO" ]; then
            git clone git://github.com/openstack/$REPO.git $SHARE/$REPO
        fi
        if [ ! -e "/opt/stack/$REPO" ]; then
            ln -s $SHARE/$REPO /opt/stack/$REPO
        fi
    done
}

function update_user() {
    echo Updating user vagrant.
    TROVE_INSTALLED="/home/vagrant/.trove-installed"
    if [ ! -e "$TROVE_INSTALLED" ]; then
        ln -s /opt/stack/trove-integration /home/vagrant/trove-integration
        sed -i '$a\export PATH=$PATH:/sbin' /home/vagrant/.bashrc
        sed -i '$a\export USE_UUID_TOKEN=True' /home/vagrant/.bashrc
        chown vagrant /opt/stack
        SSH_CFG=/home/vagrant/.ssh/config
        mkdir -p /home/vagrant/.ssh
        echo "Host 10.0.0.*" >> $SSH_CFG
        echo "    StrictHostKeyChecking no" >> $SSH_CFG
        echo "    UserKnownHostsFile /dev/null" >> $SSH_CFG
        touch "$TROVE_INSTALLED"
    fi
}

function add_fix_iptables() {
    echo Creating fix-iptables.sh
    FIXSH="/usr/local/bin/fix-iptables.sh"
    if [ ! -e "$FIXSH" ]; then
        echo "#!/bin/bash" > $FIXSH
        echo "sudo iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE" >> $FIXSH
        chmod +x $FIXSH
    fi
}

function add_redstack() {
    echo Creating redstack command
    REDSTACK="/usr/local/bin/redstack"
    if [ ! -e "$REDSTACK" ]; then
        echo "#!/bin/bash" > $REDSTACK
        echo "pushd /opt/stack/trove-integration/scripts" >> $REDSTACK
        echo "./redstack \$@" >> $REDSTACK
        echo "popd" >> $REDSTACK
        chmod +x $REDSTACK
    fi
}

function add_mycnf() {
    echo Adding .my.cnf file for easy DB access
    MYCNF="/home/vagrant/.my.cnf"
    if [ ! -e $MYCNF ]; then
        # Set SERVICE_HOST to not require extra functions
        SERVICE_HOST=localhost
        source /opt/stack/trove-integration/scripts/redstack.rc
        cat <<EOF >$MYCNF
[client]
user=root
password=$MYSQL_PASSWORD
EOF
        chown vagrant $MYCNF
    fi
}

function install() {
    # update_sources
    install_apt_repos
    install_trove_repos
    update_user
    add_fix_iptables
    add_redstack
    add_mycnf
}

function pre_install() {
    # hook for preinstall commands
    echo Installing Trove
}

function post_install() {
    # hook for post install commands
    echo Installed.
    echo Run 'vagrant ssh' to login
    echo Then run 'redstack install && redstack kick-start <datastore> && fix-iptables.sh'
}

# Allow for custom commands or overrides
if [ -e $SHARE/vagrant.rc ]; then
    source $SHARE/vagrant.rc
fi

# Run the install
pre_install
install
post_install
