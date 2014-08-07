define :magento_cache_servers do

  # Set page cache servers
  if !node[:rax][:magento][:pagecache][:servers].empty? && Chef::Recipe::Magento.tables_exist?(node[:magento][:db][:host], node[:magento][:db][:username], node[:magento][:db][:password], node[:magento][:db][:database])
    cache_servers = String.new
    cache_tmp = Array.new

    if node[:rax][:magento][:pagecache][:servers][0].kind_of?(Array) # If this is an array of arrays
      node[:rax][:magento][:pagecache][:servers].each do |a|
        a.each do |ip|
          cache_tmp.push(ip)
        end
      end
    else
      cache_tmp = node[:rax][:magento][:pagecache][:servers]
    end

    cache_tmp.uniq.each do |ip|
      if cache_servers.empty?
        cache_servers = ip
      else
        cache_servers = cache_servers + ";#{ip}"
      end
    end

    # Configuration for PageCache module to be enabled
    execute "pagecache-database-update" do
      command "/usr/bin/mysql #{node[:magento][:db][:database]} -u root -h localhost -P #{node[:mysql][:port]} -p#{node[:mysql][:server_root_password]} < /root/pagecache_update.sql"
      action :nothing
    end

    # Initializes the page cache configuration
    template "/root/pagecache_update.sql" do
      source "pagecache_update.sql.erb"
      mode "0644"
      owner "root"
      variables(
        :varnishservers => cache_servers
      )
      notifies :run, resources(:execute => "pagecache-database-update"), :immediately
    end
  end

end
