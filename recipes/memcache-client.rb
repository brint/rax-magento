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
