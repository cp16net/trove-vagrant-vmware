# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.hostname = "trove"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :forwarded_port, guest: 80, host: 8181
  config.vm.network :private_network, ip: "33.33.44.11"
  
  if ENV['TROVE_SHARE']
    config.vm.synced_folder ENV['TROVE_SHARE'], "/opt/stack"
  else
    config.vm.synced_folder "..", "/opt/stack"
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "3072"]
  end

  config.vm.provision :shell do |s|
    s.path = "install-trove.sh"
  end

end
