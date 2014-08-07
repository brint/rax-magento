define :magento_database do

  # necessary for mysql gem installation
  package "make" do
    action :install
  end

  case node[:platform_family]
  when "rhel", "fedora"

    package "mysql-devel" do
      action :install
    end

    chef_gem "mysql" do
      action :install
    end

  else
    gem_package "mysql" do
      action :install
    end

  end

  include_recipe "mysql::server"

  execute "mysql-install-mage-privileges" do
    command "/usr/bin/mysql -u root -h localhost -P #{node[:mysql][:port]} -p#{node[:mysql][:server_root_password]} < /etc/mysql/mage-grants.sql"
    action :nothing
  end

  # Initialize permissions and users
  template "/etc/mysql/mage-grants.sql" do
    path "/etc/mysql/mage-grants.sql"
    source "grants.sql.erb"
    owner "root"
    group "root"
    mode "0600"
    variables(:database => node[:magento][:db])
    notifies :run, resources(:execute => "mysql-install-mage-privileges"), :immediately
  end

  execute "create #{node[:magento][:db][:database]} database" do
    command "/usr/bin/mysqladmin -u root -h localhost -P #{node[:mysql][:port]} -p#{node[:mysql][:server_root_password]} create #{node[:magento][:db][:database]}"
    not_if do
      require 'rubygems'
      Gem.clear_paths
      require 'mysql'
      m = Mysql.new("localhost", "root", node[:mysql][:server_root_password], "mysql", node[:mysql][:port].to_i)
      m.list_dbs.include?(node[:magento][:db][:database])
    end
  end

  # Setup /root/.my.cnf for easier management
  template "/root/.my.cnf" do
    source "dotmy.cnf.erb"
    owner "root"
    group "root"
    mode "0600"
    variables(
      :rootpasswd => node['mysql']['server_root_password'],
      :port => node['mysql']['port']
    )
  end

  # save node data after writing the MYSQL root password, so that a failed chef-client run that gets this far doesn't cause an unknown password to get applied to the box without being saved in the node data.
  unless Chef::Config[:solo]
    ruby_block "save node data" do
      block do
        node.save
      end
      action :create
    end
  end

end
