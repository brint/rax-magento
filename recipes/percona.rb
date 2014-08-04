# Encoding: utf-8
# Swap MySQL for percona

case node['platform']
when 'centos', 'fedora', 'rhel'
  %w(mysql mysql-devel mysql-server perl-DBD-MySQL php-mysql).each do |pkg|
    package pkg do
      action :remove
      not_if 'rpm -aq | grep -i ^Percona-Server-server'
    end
  end
when 'debian', 'ubuntu'
  %w(mysql-client-core-5.5 mysql-server-core-5.5).each do |pkg|
    package pkg do
      action :remove
      not_if 'dpkg -l | grep ^percona-server-server'
    end
  end
end

include_recipe 'percona-install::server'

case node['platform']
when 'centos', 'fedora', 'rhel'
  service 'mysql' do
    action [:enable, :start]
  end
  package 'php-mysql'
when 'debian', 'ubuntu'
  package 'curl'
end
