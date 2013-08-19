You'll need VMWare Fusion, and the VMWare Fusion Provisioner for Vagrant.

To get things started:

    vagrant up --provider=vmware_fusion
    vagrant ssh
    ./redstack install
    ./redstack kick-start mysql
    ./fix-iptables.sh
    ./redstack int-tests --group=blackbox

There are two optional environment variables the Vagrantfile looks for:

    TROVE_VM_SOURCE_DIR
        The directory on the host that will be shared with the VM.
        If it's not specified, the directory above this directory (`./../') is used.
&nbsp;

    TROVE_VM_SYNC_DIR
        The directory on the VM that the above directory will be available at.
        If it's not specified, `/vagrant` is used.


Special thanks to Ryan Skoblenick:
http://www.skoblenick.com/vagrant/creating-a-custom-box-from-scratch/
