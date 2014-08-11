# Encoding: utf-8

# This recipe is for setting up web nodes. The Magento installation will be
# copied over by lsync.

unless File.exist?(File.join(node[:magento][:dir], '.installed'))
  case node['platform_family']
  when 'rhel', 'fedora'
    include_recipe 'yum'
    include_recipe 'yum-epel'
  else
    include_recipe 'apt'
  end

  webserver = node[:magento][:webserver]
  user = node[:magento][:user]
  group = node[webserver]['group']
  php_conf =  if platform?('centos', 'redhat')
                ['/etc', '/etc/php.d']
              else
                ['/etc/php5/fpm', '/etc/php5/conf.d']
              end

  user "#{user}" do
    comment 'magento guy'
    home node[:magento][:dir]
    system true
  end

  include_recipe 'php-fpm'

  package 'libmcrypt' if platform?('centos', 'redhat')

  node[:magento][:packages].each do |pkg|
    package pkg do
      action :upgrade
    end
  end

  # Ubuntu Polyfills
  if platform?('ubuntu', 'debian')
    bash 'Tweak CLI php.ini file' do
      cwd '/etc/php5/cli'
      code <<-EOH
      sed -i 's/memory_limit = .*/memory_limit = 128M/' php.ini
      sed -i 's/;realpath_cache_size = .*/realpath_cache_size = 32K/' php.ini
      sed -i 's/;realpath_cache_ttl = .*/realpath_cache_ttl = 7200/' php.ini
      EOH
    end
  end

  bash 'Tweak apc.ini file' do
    cwd php_conf[1] # module ini files
    code <<-EOH
    grep -q -e 'apc.stat=0' apc.ini || echo "apc.stat=0" >> apc.ini
    EOH
  end

  bash 'Tweak FPM php.ini file' do
    cwd php_conf[0] # php.ini location
    code <<-EOH
    sed -i 's/memory_limit = .*/memory_limit = 128M/' php.ini
    sed -i 's/;realpath_cache_size = .*/realpath_cache_size = 32K/' php.ini
    sed -i 's/;realpath_cache_ttl = .*/realpath_cache_ttl = 7200/' php.ini
    EOH
    notifies :restart, resources(service: 'php-fpm')
  end

  directory node[:magento][:dir] do
    owner user
    group group
    mode 0755
    action :create
    recursive true
  end

  include_recipe "magento::_web_#{node[:magento][:webserver]}"

  directory File.join(node[:magento][:dir], '.ssh') do
    owner user
    group group
    mode 0700
    action :create
    recursive true
  end

  file File.join(node[:magento][:dir], '.ssh', 'id_rsa.pub') do
    content node['rax']['lsyncd']['ssh']['pub']
    owner user
    group group
    mode 0644
    action :create
  end
end
