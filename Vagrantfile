Vagrant.configure("2") do |config|

  SOURCE_DIR = ENV['TROVE_VM_SOURCE_DIR'] || "../"
  SYNC_DIR = ENV['TROVE_VM_SYNC_DIR'] || "/trove"
  MEMORY = ENV['TROVE_VM_MEMORY'] || 2048

  config.vm.synced_folder SOURCE_DIR, SYNC_DIR
  config.vm.provision :shell, :path => "install-trove.sh", :args => SYNC_DIR

  config.vm.provider :vmware_fusion do |vmf, override|
    config.vm.box = "openstack-trove"
    config.vm.box_url = "http://9e1a2926d405d51127ce-1dd7910aaf75de5d703b77f114f87ea9.r5.cf1.rackcdn.com/openstack-trove.box"
    vmf.gui = "TRUE"
    vmf.vmx["memsize"] = MEMORY

  end

  config.vm.provider :virtualbox do |vb, override|
    override.vm.box = "precise64"
    override.vm.box_url = "http://files.vagrantup.com/precise64.box"
    vb.customize ["modifyvm", :id, "--memory", MEMORY.to_s]
  end
    
end
# vim: set ft=ruby:
