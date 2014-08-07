class Chef::Recipe::Magento


  # Take a plain text password and hash it Magento style
  def self.hash_password(password, salt)
    require 'rubygems'
    require 'digest/md5'
    require 'securerandom'
    salt = SecureRandom.uuid.gsub('-', '').byteslice(0..1) if !salt || salt.length < 2
    return Digest::MD5.hexdigest(Digest::MD5.digest(salt + password)) + ":#{salt}"
  end


  # Take a value and return a string for use in SQL insert statements
  def self.null_or_value(value)
    return "NULL" if value.empty?
    # Escape any single quotes to encure values returned do not not cause
    # issues with the SQL insert statement
    return "'#{value.gsub("'", "\\\\'")}'"
  end


  # Create magento encryption key mimicing how Magento does it
  def self.magento_encryption_key 
    require 'rubygems'
    require 'securerandom'
    return SecureRandom.uuid.gsub('-', '')
  end

  # Determine if an IP is local to this machine
  def self.ip_is_local?(node, ip)
    return true if ip == 'localhost' || ip == '127.0.0.1'
    node['network']['interfaces'].each do |iface|
      node['network']['interfaces'][iface[0]]['addresses'].each do |addr|
        return true if addr[0] == ip
      end
    end
    return false
  end

  # Determine if tables exist for specific database
  def self.tables_exist?(host, username, password, database)
    begin
      require 'rubygems'
      require 'mysql'
      m = Mysql.new(host, username, password, database)
      t = m.list_tables
      return false if t.empty?
      return true
    rescue Exception => e
      return false
    end
  end

  def self.reindex_all(path)
    begin
      system("php -f #{path} reindexall")
    rescue Exception => e
      # If this cache building fails, it's not fatal
      # This is in place since you cannot easily do this within a recipe
      return true 
    end
  end

end
