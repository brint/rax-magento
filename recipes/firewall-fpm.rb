#
# Cookbook Name:: rax-magento
# Recipe:: firewall-fpm
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

fpm_port = node['php-fpm']['pools'][0]['listen'].split(":")[1].to_i

case node["platform_family"]
when "rhel", "fedora"
  fwfile = "/etc/sysconfig/iptables"

  node['rax']['php-fpm']['slaves'].flatten.each do |ip|
    rule = "-I INPUT -s #{ip} -p tcp -m tcp --dport #{fpm_port} -j ACCEPT"
    execute "Adding fpm iptables rule for #{ip}" do
      command "iptables #{rule}"
      not_if "grep \"\\#{rule}\" #{fwfile}"
    end
  end
  # Save iptables rules
  execute "Saving memcached iptables rule set" do
    command "/sbin/service iptables save"
  end
else
  include_recipe "firewall"

  node['rax']['php-fpm']['slaves'].flatten.each do |ip|
    firewall_rule "php-fpm allow #{ip}" do
      port fpm_port
      source ip
      action :allow
    end
  end
end
