You'll need VMWare Fusion, and the VMWare Fusion Provisioner for Vagrant.

To get things started:

    $ vagrant up --provider=vmware_fusion
    $ vagrant ssh

Install Trove:

    $ redstack install
    $ redstack kick-start mysql

Running tests:

    $ fix-iptables.sh
    $ redstack int-tests --group=blackbox

Using the local mysql client:

    $ mysql
    mysql> use trove
    mysql> select * from instances;
    Empty set (0.00 sec)

There are three optional environment variables the Vagrantfile looks for:

<dl>
  <dt>TROVE_VM_SOURCE_DIR</dt>
  <dd>The directory on the host that will be shared with the VM. If it's not
      specified, the directory above this directory `./../` is used.</dd>

  <dt>TROVE_VM_SYNC_DIR</dt>
  <dd>The directory on the VM that the above directory will be available at.
      If it's not specified, `/trove` is used.</dd>

  <dt>TROVE_VM_MEMORY</dt>
  <dd>Set the amount of RAM to use for the VM. Default is 2048</dd>
</dl>


Special thanks to Ryan Skoblenick:
http://www.skoblenick.com/vagrant/creating-a-custom-box-from-scratch/
