# Encoding: utf-8
#
# Cookbook Name:: rax-magento
# Recipe:: default
#
# Copyright 2014, Rackspace
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This recipe will build a single server Magento Deployment

if node[:rax][:magento][:varnish][:use_varnish]
  node.set[:magento][:http_port] = node[:rax][:magento][:varnish][:backend_http]
end

include_recipe 'magento::default'

include_recipe 'rax-magento::php_fpm'
include_recipe 'rax-magento::my_cnf'

unless File.exist?(File.join(node[:magento][:dir], '.configured'))
  node.set_unless[:rax][:magento][:encryption_key] = Magento.magento_encryption_key
  magento_initial_configuration
end

include_recipe 'rax-magento::memcache-client'

bash 'Set permissions for local.xml*' do
  code "chmod 600 #{File.join(node['magento']['dir'], 'app/etc/local.xml')}*"
end

include_recipe 'rax-magento::memcached'
include_recipe 'rax-magento::varnish' if node[:rax][:magento][:varnish][:use_varnish]

Magento.reindex_all(File.join(node[:magento][:dir], '/shell/indexer.php'))
