Vagrant.configure("2") do |config|
  config.vm.box = "openstack-trove"
  config.vm.box_url = "http://9e1a2926d405d51127ce-1dd7910aaf75de5d703b77f114f87ea9.r5.cf1.rackcdn.com/openstack-trove.box"
  config.vm.provision :shell, :path => "install-trove.sh"

  config.vm.provider :vmware_fusion do |vmf|
    vmf.gui = "TRUE"
    vmf.vmx["memsize"] = 3072

  end

  config.vm.synced_folder "../", "/trove"
  
end
# vim: set ft=ruby:
