# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.box = "ubuntu/trusty64"
  config.vm.define 'redis01' do |machine|
    config.vm.network "private_network", ip: "192.168.33.10"
  end
  config.vm.define 'redis02' do |machine|
    config.vm.network "private_network", ip: "192.168.33.11"
  end
  config.vm.define 'redis03' do |machine|
    config.vm.network "private_network", ip: "192.168.33.12"
  end

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provision "puppet" do |puppet|
    puppet.module_path       = "modules"
    puppet.hiera_config_path = "hiera.yaml"
    puppet.working_directory = "/tmp/vagrant-puppet"
  end
end
