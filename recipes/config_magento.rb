# Encoding: utf-8

unless File.exist?(File.join(node[:magento][:dir], '.configured'))
  node.set_unless[:rax][:magento][:encryption_key] = Magento.magento_encryption_key
  magento_initial_configuration
end
