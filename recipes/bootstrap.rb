# Include the services recipe
include_recipe 'olyn_percona::services'

# Load information about the current server from the servers data bag
local_server = data_bag_item('servers', node[:hostname])

# Initiate/bootstrap the cluster
execute 'percona_bootstrap' do
  command 'systemctl start mysql@bootstrap.service' \
          ' && ' \
          "touch #{Chef::Config[:file_cache_path]}/percona.bootstrapper.init.lock"
  creates "#{Chef::Config[:file_cache_path]}/percona.bootstrapper.init.lock"
  action :run
  notifies :stop, 'service[mysql]', :before
  only_if { local_server[:options][:percona][:bootstrapper] }
end

# Start MySQL non-bootsrappers
file "#{Chef::Config[:file_cache_path]}/percona.member.init.lock" do
  action :create_if_missing
  only_if { !local_server[:options][:percona][:bootstrapper] }
  notifies :start, 'service[mysql]', :immediately
end
