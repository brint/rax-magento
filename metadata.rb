# Encoding: utf-8
name 'rax-magento'
maintainer 'Brint O\'Hearn'
maintainer_email 'brint.ohearn@rackspace.com'
license 'Apache 2.0'
description 'Installs/Configures Magento'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.1'

depends 'magento', '>= 0.8.6'
depends 'php-fpm'
depends 'percona-install'
depends 'memcached'
depends 'varnish'
depends 'lsyncd'
