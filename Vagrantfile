# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.hostname = 'magento-rackspace'
  case ENV['VMBOX']
  when 'centos65'
    config.vm.box = "centos-6.5"
  else
    config.vm.box = 'ubuntu-12.04'
  end
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_#{config.vm.box}_chef-provisionerless.box"
  config.vm.network :private_network, ip: '33.33.33.11'
  config.omnibus.chef_version = 'latest'
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :mysql => {
        :server_root_password => 'rootpass',
        :server_debian_password => 'debpass',
        :server_repl_password => 'replpass'
      },
      :magento => {
        :db => {
          :password => 'magepass'
        },
        :sample_data_url => 'http://www.magentocommerce.com/downloads/assets/1.6.1.0/magento-sample-data-1.6.1.0.tar.gz'
      }
    }

    chef.run_list = [
        'recipe[magento-rackspace::default]'
    ]
  end
end
