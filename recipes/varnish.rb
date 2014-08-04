# Encoding: utf-8
# Setup Varnish and PageCache

case node["platform_family"]
when "rhel", "fedora"
  # CentOS installs v2.1 by default, installing 3.0
  execute 'reload-external-yum-cache' do
    command 'yum makecache'
    action :nothing
  end

  ruby_block "reload-internal-yum-cache" do
    block do
      Chef::Provider::Package::Yum::YumCache.instance.reload
    end
    action :nothing
  end

  execute "Install varnish-release" do
    not_if "rpm -qa | grep -qx 'varnish-release-3.0-1'"
    command "rpm -Uvh --nosignature --replacepkgs http://repo.varnish-cache.org/redhat/varnish-3.0/el6/noarch/varnish-release/varnish-release-3.0-1.el6.noarch.rpm"
    action :run
    notifies :run, resources(:execute => 'reload-external-yum-cache'), :immediately
    notifies :create, resources(:ruby_block => 'reload-internal-yum-cache'), :immediately
  end

  package "varnish" do
    action :install
  end

  service "varnish" do
    action [:enable, :start]
  end

  template "/etc/sysconfig/varnish" do
    cookbook "rax-magento"
    source "varnish.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, "service[varnish]"
  end


else
  node.set['varnish']['version'] = '3.0'
  include_recipe "varnish"

  service "varnish" do
    action [:enable, :start]
  end

  template "/etc/default/varnish" do
    cookbook "rax-magento"
    source "varnish.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, "service[varnish]"
  end

end

php_conf =  if platform?('centos', 'redhat')
                ["/etc", "/etc/php.d"]
              else
                ["/etc/php5/fpm", "/etc/php5/conf.d"]
              end

file File.join(node[:magento][:dir], 'mage') do
  mode 0744
  owner node[:magento][:system_user]
end

execute "Configuring Mage php.ini location" do
  cwd node[:magento][:dir]
  user node[:magento][:system_user]
  command "./mage config-set php_ini #{File.join(php_conf, 'php.ini')}"
end

execute "Install Community Varnish Cache" do
  cwd node[:magento][:dir]
  user node[:magento][:system_user]
  command <<-EOH
  ./mage channel-add http://connect20.magentocommerce.com/community
  ./mage install community Varnish_Cache
  EOH
end

execute "Copying Community Varnish Configuration" do
  user 'root'
  command "cp -f #{node[:magento][:dir]}/app/code/community/Phoenix/VarnishCache/etc/default_3.0.vcl /etc/varnish/default.vcl"
  notifies :restart, 'service[varnish]'
end

execute "Allow Varnish PURGE from ServiceNet" do
  user "root"
  command "sed -i 's/^acl purge \{/acl purge \{\\n  \"localhost\";\\n  \"10.0.0.0\"\\\/8;/g' /etc/varnish/default.vcl"
  notifies :restart, "service[varnish]"
end
