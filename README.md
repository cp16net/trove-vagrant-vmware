You'll need VMWare Fusion, and the VMWare Fusion Provisioner for Vagrant.

    vagrant up --provider=vmware_fusion
    vagrant ssh
    sudo su - ubuntu
    ./redstack int-tests
