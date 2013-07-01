Vagrant.configure("2") do |config|
  config.vm.hostname = 'trove.clouddb.rackspace.net'
  config.vm.box = "openstack-trove"
  config.vm.provision :shell, :path => "install-trove.sh"

  config.vm.provider :vmware_fusion do |vmf|
    vmf.gui = "TRUE"

  end

  config.vm.synced_folder "../", "/trove"
  
end
