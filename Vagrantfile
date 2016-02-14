# -*- mode: ruby -*-
# vi: set ft=ruby :
#
Vagrant.configure(2) do |config|
  config.ssh.forward_agent = true
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  if !Vagrant.has_plugin?('vagrant-hostmanager')
    puts 'Required plugin vagrant-hostmanager is not installed! Install with "vagrant plugin install vagrant-hostmanager"'
    exit
  end

  config.vm.define 'Sinatra Api Server' do |node|
    node.vm.box = "hashicorp/precise32"
    node.vm.network :private_network, ip: "192.168.100.103"
    node.vm.synced_folder "./", "/var/www/app/", :mount_options => ["dmode=777", "fmode=664"]
    node.vm.hostname = 'server.dev'
    node.hostmanager.aliases = %w(www.server.dev server.dev)
    node.vm.provision :shell do |sh|
      sh.path = "provision/provision.sh"
    end
  end
end

