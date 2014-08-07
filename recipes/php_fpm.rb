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

# The following should only be used in the case where there are multiple web
# servers, and the master node needs to process admin-type requests. The
# fpm_allow definition will allow other nodes to communicate directly with FPM.
fpm_allow if node[:rax][:magento][:master]
