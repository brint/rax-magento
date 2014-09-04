define :nginx_setup do
  service 'nginx'
  master = node['rax']['php-fpm']['master']
  local = "127.0.0.1"

  if Chef::Recipe::Magento.ip_is_local?(node, node['rax']['php-fpm']['master'])
    local = node['rax']['php-fpm']['master']
  end

  template File.join(node[:nginx][:dir], 'conf.d/routing.conf') do
    source 'routing.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables(
      :master => master,
      :local => local
    )
    action :create_if_missing
    notifies :reload, "service[nginx]"
  end

  %w(default ssl).each do |site|
    template File.join(node[:nginx][:dir], 'sites-available', site) do
      cookbook 'rax-magento'
      source 'nginx-site.erb'
      owner 'root'
      group 'root'
      mode 0644
      variables(
        path: node[:magento][:dir],
        ssl: (site == 'ssl') ? true : false,
        ssl_cert: File.join(node[:nginx][:dir], 'ssl',
                            node[:magento][:cert_name]),
        ssl_key: File.join(node[:nginx][:dir], 'ssl', node[:magento][:cert_name])
      )
    end
    nginx_site site do
      template nil
      notifies :reload, resources(service: 'nginx')
    end
  end
end
