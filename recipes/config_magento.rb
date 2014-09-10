# Encoding: utf-8

unless File.exist?(File.join(node[:magento][:dir], '.configured'))
  execute "Nuke local.xml for initial setup" do
    command "rm -f #{File.join(node[:magento][:dir], 'app/etc/local.xml')}"
    action :run
  end
  node.set_unless[:rax][:magento][:encryption_key] = Magento.magento_encryption_key
  magento_initial_configuration
end
