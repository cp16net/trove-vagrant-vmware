You'll need VMWare Fusion, and the VMWare Fusion Provisioner for Vagrant.

    vagrant up --provider=vmware_fusion
    vagrant ssh
    sudo su - trove
    ./redstack install
    ./redstack kick-start mysql
    ./fix-iptables.sh
    ./redstack int-tests
