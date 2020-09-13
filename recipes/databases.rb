# Load information about the current server from the servers data bag
local_server = data_bag_item('servers', node[:hostname])

# Load the MySQL root user data bag item
root_user = data_bag_item(node[:olyn_database][:users][:data_bag], node[:olyn_database][:users][:root][:data_bag_item])

# Loop through each database item in the data bag
data_bag('databases').each do |database_item|

  # Load the data bag item
  database = data_bag_item('databases', database_item)

  # Create the database if it doesn't exist yet
  execute "create_database_#{database[:name]}" do
    command "mysql -u root -p\"#{root_user[:password]}\" -e \"" \
              "CREATE DATABASE IF NOT EXISTS #{database[:name]} DEFAULT CHARACTER SET #{database[:character_set]} COLLATE #{database[:collation]};\"" \
            ' && ' \
            "touch #{Chef::Config[:file_cache_path]}/db.#{database[:name]}.create.lock"
    creates "#{Chef::Config[:file_cache_path]}/db.#{database[:name]}.create.lock"
    action :run
    only_if { local_server[:options][:bootstrapper] }
    sensitive true
  end

  # Import the SQL file if it exists
  execute "import_database_#{database[:name]}" do
    command "mysql -u root -p\"#{root_user[:password]}\" #{database[:name]} < #{database[:import_sql_file]}" \
            ' && ' \
            "touch #{Chef::Config[:file_cache_path]}/db.#{database[:name]}.import.lock"
    creates "#{Chef::Config[:file_cache_path]}/db.#{database[:name]}.import.lock"
    action :run
    not_if { database[:import_sql_file].nil? }
    only_if { File.exist?(database[:import_sql_file]) }
    only_if { local_server[:options][:bootstrapper] }
    sensitive true
  end

  # Now remove the original SQL files
  file database[:import_sql_file] do
    action :delete
    not_if { database[:import_sql_file].nil? }
    only_if { File.exist?(database[:import_sql_file]) }
  end
end
