# Percona repo
default[:olyn_percona][:release_manager][:url]  = 'https://repo.percona.com/apt/percona-release_latest.generic_all.deb'
default[:olyn_percona][:release_manager][:file] = "#{Chef::Config[:file_cache_path]}/percona-release_latest.generic_all.deb"
default[:olyn_percona][:release_manager][:repo] = 'pxc-80'

# Percona packages
default[:olyn_percona][:packages][:base]   = 'percona-xtradb-cluster'
default[:olyn_percona][:packages][:server] = 'percona-xtradb-cluster-server'

# Config file locations on the server
default[:olyn_percona][:config_files][:mysqld_file] = '/etc/mysql/mysql.conf.d/mysqld.cnf'
default[:olyn_percona][:config_files][:client_file] = '/etc/mysql/mysql.conf.d/client.cnf'

# Default collation and character set
default[:olyn_percona][:configs][:character_set] = 'utf8mb4'
default[:olyn_percona][:configs][:collation] = 'utf8mb4_unicode_520_ci'

# Percona packages data bag item
default[:olyn_percona][:percona_packages_data_bag_item] = 'percona'

# MySQL root user
default[:olyn_percona][:users][:root][:data_bag_item] = 'percona_root'

# The name of Percona seed file for debconf
default[:olyn_percona][:seed_file][:name] = 'percona.seed.erb'

# Default password for root during install
default[:olyn_percona][:seed_file][:initial_password] = 'TemporaryPW'

# Use legacy authentication method for 5.x backwards compatibility?
default[:olyn_percona][:seed_file][:use_legacy_auth] = false

# Port data bag items
default[:olyn_percona][:ports][:group][:data_bag_item] = 'percona_group'
default[:olyn_percona][:ports][:mysql][:data_bag_item] = 'percona_mysql'
default[:olyn_percona][:ports][:ist][:data_bag_item]   = 'percona_ist'
default[:olyn_percona][:ports][:sst][:data_bag_item]   = 'percona_sst'

# SSL Certificate data bag items
default[:olyn_percona][:ssl_certificates][:server_data_bag_item] = 'percona_server'
default[:olyn_percona][:ssl_certificates][:client_data_bag_item] = 'percona_client'
