# Encoding: utf-8
# Recipe for setting up a stand alone Database server to use with Magento

installed_file = "/root/.magento.mysql.installed"

unless File.exists?(installed_file)

  case node["platform_family"]
  when "rhel", "fedora"
    include_recipe "yum"
  else
    include_recipe "apt"
  end

  include_recipe "mysql::client"
  include_recipe "mysql-chef_gem"

  my_cnf =  if platform?('centos', 'redhat')
                "/etc"
              else
                "/etc/mysql"
              end

  # Install and configure MySQL
  magento_database

  db = node[:magento][:db]
  mysql = node[:mysql]

  # Import Sample Data
  if node[:magento][:use_sample_data] && !Magento.tables_exist?('localhost', db[:username], db[:password], db[:database])
    remote_file "#{Chef::Config[:file_cache_path]}/magento-sample-data.tar.gz" do
      source node[:magento][:sample_data_url]
      mode "0644"
    end

    bash "magento-sample-data" do
      cwd "#{Chef::Config[:file_cache_path]}"
      code <<-EOH
        mkdir #{name}
        cd #{name}
        tar --strip-components 1 -xzf #{Chef::Config[:file_cache_path]}/magento-sample-data.tar.gz
        mv media/* #{node[:magento][:dir]}/media/

       mv magento_sample_data*.sql data.sql 2>/dev/null
        /usr/bin/mysql -h #{node[:mysql][:bind_address]} -P #{node[:mysql][:port]} -u #{node[:magento][:db][:username]} -p#{node[:magento][:db][:password]} #{node[:magento][:db][:database]} < data.sql
        cd ..
        rm -rf #{name}
        EOH
    end
  end
  bash "Touch #{installed_file} file" do
    require 'time'
    code "echo '# File Created by Chef' > #{installed_file} ; echo '#{Time.new.rfc2822()}' >> #{installed_file}"
  end
end

# Add cache servers included in node[:rax][:magento][:pagecache][:servers]
magento_cache_servers if node[:rax][:magento][:varnish][:use_varnish]
