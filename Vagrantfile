Vagrant.configure("2") do |config|
  config.vm.provision :shell, :path => "install-trove.sh"

  config.vm.provider :vmware_fusion do |vmf, override|
    override.vm.box = "openstack-trove"
    override.vm.box_url = "http://9e1a2926d405d51127ce-1dd7910aaf75de5d703b77f114f87ea9.r5.cf1.rackcdn.com/openstack-trove.box"
    vmf.gui = "TRUE"
    vmf.vmx["memsize"] = 3072
  end

  # DOESNT WORK CORRECTLY YET
  config.vm.provider :virtualbox do |vb, override|
    override.vm.box = "precise64"
    override.vm.box_url = "http://files.vagrantup.com/precise64.box"
    vb.customize ["modifyvm", :id, "--memory", "3072"]
  end

  config.vm.synced_folder "../", "/trove"

end
# vim: set ft=ruby:
