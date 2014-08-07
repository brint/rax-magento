# Encoding: utf-8

# Magento Admin User
default[:rax][:magento][:admin_user][:firstname] = 'Admin' # Required
default[:rax][:magento][:admin_user][:lastname] = 'User' # Required
default[:rax][:magento][:admin_user][:email] = 'admin@example.org' # Required
default[:rax][:magento][:admin_user][:username] = 'MagentoAdmin' # Required
default[:rax][:magento][:admin_user][:password] = 'magPass.123' # Required

# Memcached Server Session Settings
default[:rax][:magento][:memcached][:sessions][:memory] = 512
default[:rax][:magento][:memcached][:sessions][:port] = 11211
default[:rax][:magento][:memcached][:sessions][:maxconn] = 2048
default[:rax][:magento][:memcached][:sessions][:listen] = "127.0.0.1"
default[:rax][:magento][:memcached][:sessions][:interface] = "eth1"
default[:rax][:magento][:memcached][:clients] = []

# Memcached Server Slow Backend Settings
default[:rax][:magento][:memcached][:slow_backend][:memory] = 1536
default[:rax][:magento][:memcached][:slow_backend][:port] = 11212
default[:rax][:magento][:memcached][:slow_backend][:maxconn] = 2048
default[:rax][:magento][:memcached][:slow_backend][:listen] = "127.0.0.1"
default[:rax][:magento][:memcached][:slow_backend][:interface] = "eth1"

# Memcached Server, used for configuring client servers
default[:rax][:magento][:memcached][:servers][:sessions][:servers] = "127.0.0.1"
default[:rax][:magento][:memcached][:servers][:sessions][:server_port] = 11211

default[:rax][:magento][:memcached][:servers][:slow_backend][:servers] = "127.0.0.1"
default[:rax][:magento][:memcached][:servers][:slow_backend][:server_port] = 11212
default[:rax][:magento][:memcached][:servers][:slow_backend][:persistent] = 1
default[:rax][:magento][:memcached][:servers][:slow_backend][:weight] = 1
default[:rax][:magento][:memcached][:servers][:slow_backend][:timeout] = 1
default[:rax][:magento][:memcached][:servers][:slow_backend][:retry_interval] = 15
default[:rax][:magento][:memcached][:servers][:slow_backend][:compression] = 0

# Varnish config
default[:rax][:magento][:varnish][:use_varnish] = true
default[:rax][:magento][:varnish][:backend_http] = 8080
default[:rax][:magento][:varnish][:http_port] = 80
default[:rax][:magento][:varnish][:memory] = "#{(node['memory']['total'].to_i / 4) / (1024)}M"

# Page cache servers
default[:rax][:magento][:pagecache][:servers] = ['127.0.0.1']

# Attributes for initial configuration of Magento
default[:rax][:magento][:db][:prefix] = ''
default[:rax][:magento][:db][:initStatements] = 'SET NAMES utf8'
default[:rax][:magento][:db][:model] = 'mysql4'
default[:rax][:magento][:db][:type] = 'pdo_mysql'
default[:rax][:magento][:db][:pdoType] = ''
default[:rax][:magento][:db][:active] = '1'
default[:rax][:magento][:locale] = 'en_US'
default[:rax][:magento][:timezone] = 'America/Chicago'
default[:rax][:magento][:default_currency] = 'USD'
default[:rax][:magento][:admin_frontname] = 'admin'
default[:rax][:magento][:url] = "http://#{node[:magento][:domain]}/"
default[:rax][:magento][:use_rewrites] = 'yes'
default[:rax][:magento][:use_secure] = 'yes'
default[:rax][:magento][:secure_base_url] = "https://#{node[:magento][:domain]}/"
default[:rax][:magento][:use_secure_admin] = 'yes'
default[:rax][:magento][:enable_charts] = 'yes'

# FPM Settings
default['rax']['php-fpm']['master'] = '127.0.0.1'
default['rax']['php-fpm']['slaves'] = []

# Role settings
default[:rax][:magento][:master] = false # true if master web node
default[:rax][:magento][:single] = true # true if single server deployment
