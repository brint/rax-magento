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

node.set_unless[:magento][:session][:save_path] = "tcp://#{node[:rax][:magento][:memcached][:servers][:sessions][:servers]}:#{node[:rax][:magento][:memcached][:servers][:sessions][:server_port]}?persistent=0&amp;weight=2&amp;timeout=10&amp;retry_interval=10"
