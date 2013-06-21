# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.hostname = 'trovenode.clouddb.rackspace.net'
  config.vm.box = "precise64_vmware"
  config.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
  config.vm.provision :shell, :path => "install-trove.sh"

  config.vm.network :forwarded_port, guest: 8778, host: 8778 # reddwarf-api
  config.vm.network :forwarded_port, guest: 8779, host: 8779 # reddwarf-api
  config.vm.network :forwarded_port, guest: 5672, host: 5672 # rabbitmq
  config.vm.network :forwarded_port, guest: 55672, host: 55672 # rabbitmq management
  
end
