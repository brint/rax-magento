# Encoding: utf-8
# Remove default fpm configuration

include_recipe 'php-fpm'

case node['platform']
when 'rhel', 'centos', 'fedora'
  php_fpm_service = 'php-fpm'
when 'debian', 'ubuntu'
  php_fpm_service = 'php5-fpm'
end

file File.join(node['php-fpm']['pool_conf_dir'], 'www.conf') do
  backup false
  action :delete
  notifies :restart, "service[php-fpm]", :immediately
end
