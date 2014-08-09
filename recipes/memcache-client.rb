# Encoding: utf-8

case node[:platform]
when "ubuntu", "debian"
  package "php5-memcache" do
    action :install
    notifies :restart, "service[php-fpm]"
  end
when "centos", "fedora"
  package "php-pecl-memcache" do
    action :install
    notifies :restart, "service[php-fpm]"
  end
end

node.set[:magento][:session][:save] = 'memcache'
node.set_unless[:magento][:session][:save_path] = "tcp://#{node[:rax][:magento][:memcached][:servers][:sessions][:servers]}:#{node[:rax][:magento][:memcached][:servers][:sessions][:server_port]}?persistent=0&amp;weight=2&amp;timeout=10&amp;retry_interval=10"

template File.join(node[:magento][:dir], '/app/etc/local.xml') do
  source 'local.xml.erb'
  mode '0600'
  owner node[:magento][:user]
  group node[node[:magento][:webserver]][:group]
  variables(
    :db_host => node[:magento][:db][:host],
    :db_port => node[:mysql][:port],
    :db_name => node[:magento][:db][:database],
    :db_prefix => node[:rax][:magento][:db][:prefix],
    :db_user => node[:magento][:db][:username],
    :db_pass => node[:magento][:db][:password],
    :db_init => node[:rax][:magento][:db][:initStatements],
    :db_model => node[:rax][:magento][:db][:model],
    :db_type => node[:rax][:magento][:db][:type],
    :db_pdo => node[:rax][:magento][:db][:pdoType],
    :db_active => node[:rax][:magento][:db][:active],
    :enc_key => node[:rax][:magento][:encryption_key],
    :session => node[:magento][:session],
    :admin_path => node[:rax][:magento][:admin_frontname],
    :cache_info => node[:rax][:magento][:memcached][:servers][:slow_backend],
    :inst_date => Time.new.rfc2822()
  )
end
