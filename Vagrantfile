# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.hostname = 'trovenode.clouddb.rackspace.net'
  config.vm.box = "precise64_vmware"
  config.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
  config.vm.provision :shell, :path => "install-trove.sh"

  config.vm.provider :vmware_fusion do |v|
    v.vmx["memsize"] = "3072"
    v.vmx["numcpus"] = "1"
  end

  if ENV['TROVE_SHARE']
    config.vm.synced_folder ENV['TROVE_SHARE'], "/opt/stack"
  else
    config.vm.synced_folder "..", "/opt/stack"
  end
  
end
