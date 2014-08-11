define :nginx_setup do
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
end
