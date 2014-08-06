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
default[:rax][:magento][:pagecache][:servers] = []
