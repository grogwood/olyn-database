# Include the services recipe
include_recipe 'olyn_percona::services'

# Load information about the current server from the servers data bag
local_server = data_bag_item('servers', node[:hostname])

# Load the mysql root user data bag item
percona_root_user = data_bag_item('percona_users', node[:olyn_percona][:users][:root][:data_bag_item])

# Loop through each database user in the data bag
data_bag('percona_users').each do |user_item|

  # Load the data bag item
  user = data_bag_item('percona_users', user_item)

  # Skip this user if auto_create is disabled
  next unless user[:auto_create]

  # Create the database user if it doesn't exist yet
  execute "mysql_user_#{user[:username]}" do
    command "mysql -u root -p\"#{percona_root_user[:password]}\" -e \"" \
              "CREATE USER IF NOT EXISTS '#{user[:username]}'@'#{user[:options]['host']}' IDENTIFIED BY '#{user[:password]}';\"" \
            ' && ' \
            "touch #{Chef::Config[:file_cache_path]}/percona.user.#{user[:username]}.create.lock"
    creates "#{Chef::Config[:file_cache_path]}/percona.user.#{user[:username]}.create.lock"
    action :run
    only_if { local_server[:options][:percona][:bootstrapper] }
    sensitive true
  end

  # Grant the user permissions
  execute "mysql_user_permissions_#{user[:username]}" do
    command "mysql -u root -p\"#{percona_root_user[:password]}\" -e \"" \
              "GRANT #{user[:options]['privileges']} ON #{user[:options]['database']}.* to '#{user[:username]}'@'#{user[:options]['host']}';\"" \
            ' && ' \
            "touch #{Chef::Config[:file_cache_path]}/percona.user.#{user[:username]}.permissions.lock"
    creates "#{Chef::Config[:file_cache_path]}/percona.user.#{user[:username]}.permissions.lock"
    action :run
    only_if { local_server[:options][:percona][:bootstrapper] }
    sensitive true
  end
end
