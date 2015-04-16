# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.box = "ubuntu/trusty64"

  # create three machines running the redis cluster
  3.times do |i|
    hostname='redis' + (i+1).to_s.rjust(2, "0")
    config.vm.define hostname do |machine|
      machine.vm.network "private_network", ip: "192.168.33." + (i+10).to_s
      machine.vm.hostname = hostname
    end
  end

  # create three machines running the lamernews server
  3.times do |i|
    hostname='front' + (i+1).to_s.rjust(2, "0")
    config.vm.define hostname do |machine|
      machine.vm.network "private_network", ip: "192.168.33." + (i+100).to_s
      machine.vm.hostname = hostname
    end
  end

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provision :puppet do |puppet|
    puppet.module_path       = "modules"
    puppet.hiera_config_path = "hiera.yaml"
    puppet.working_directory = "/tmp/vagrant-puppet"
  end

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id,
                 "--nicpromisc2", "allow-all",
                 "--groups", "/Mathijs"]
  end
end
