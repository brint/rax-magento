# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: lsyncd
#
# Copyright 2014
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

include_recipe 'lsyncd'

if node['rax']['lsyncd']['ssh']['private_key']

  template '/etc/lsyncd/lsyncd.exclusions' do
    source 'lsyncd.exclude.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables(
      exclusions: node['rax']['lsyncd']['exclusions']
    )
  end

  directory File.join(node['magento']['dir'], '.ssh') do
    owner node['magento']['user']
    group node['magento']['user']
    mode '0700'
    action :create
  end

  file File.join(node['magento']['dir'], '.ssh/id_rsa') do
    content node['rax']['lsyncd']['ssh']['private_key']
    owner node['magento']['user']
    group node['magento']['user']
    mode '0600'
    action :create
  end
end

node['rax']['lsyncd']['clients'].each do |client|
  lsyncd_target client.gsub(/\./, '-') do
    source node['magento']['dir']
    target node['magento']['dir']
    user node['magento']['user']
    host client
    rsync_opts node['rax']['lsyncd']['rsync_opts']
    exclude_from node['rax']['lsyncd']['excludes_file']
    notifies :restart, 'service[lsyncd]', :delayed
  end
end

service 'lsyncd' do
  action :start
end
