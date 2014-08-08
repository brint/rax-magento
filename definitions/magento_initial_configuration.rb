define :magento_initial_configuration do
  # Configure all the things
  bash "Configure Magento" do
    cwd node[:magento][:dir]
    user node[:magento][:user]
    group node[node[:magento][:webserver]][:group]
    code  <<-EOH
    php -f install.php -- \
    --license_agreement_accepted "yes" \
    --locale "#{node[:rax][:magento][:locale]}" \
    --timezone "#{node[:rax][:magento][:timezone]}" \
    --default_currency "#{node[:rax][:magento][:default_currency]}" \
    --db_host "#{node['mysql']['bind_address']}:#{node['mysql']['port']}" \
    --db_model "#{node[:rax][:magento][:db][:model]}" \
    --db_name "#{node[:magento][:db][:database]}" \
    --db_user "#{node[:magento][:db][:username]}" \
    --db_pass "#{node[:magento][:db][:password]}" \
    --db_prefix "#{node[:rax][:magento][:db][:prefix]}" \
    --session_save "#{node[:magento][:session][:save]}" \
    --admin_frontname "#{node[:rax][:magento][:admin_frontname]}" \
    --url "#{node[:rax][:magento][:url]}" \
    --use_rewrites "#{node[:rax][:magento][:use_rewrites]}" \
    --use_secure "#{node[:rax][:magento][:use_secure]}" \
    --secure_base_url "#{node[:rax][:magento][:secure_base_url]}" \
    --use_secure_admin "#{node[:rax][:magento][:use_secure_admin]}" \
    --enable-charts "#{node[:rax][:magento][:enable_charts]}" \
    --admin_firstname "#{node[:rax][:magento][:admin_user][:firstname]}" \
    --admin_lastname "#{node[:rax][:magento][:admin_user][:lastname]}" \
    --admin_email "#{node[:rax][:magento][:admin_user][:email]}" \
    --admin_username "#{node[:rax][:magento][:admin_user][:username]}" \
    --admin_password "#{node[:rax][:magento][:admin_user][:password]}" \
    --encryption_key "#{node[:rax][:magento][:encryption_key]}" \
    --skip_url_validation
    touch .configured
    EOH
  end

end
