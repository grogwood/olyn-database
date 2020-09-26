# Load information about the current server from the servers data bag
local_server = data_bag_item('servers', node[:hostname])

# Load the MySQL root user data bag item
root_user = data_bag_item('database_users', node[:olyn_database][:user][:root][:data_bag_item])

# Loop through each database item in the data bag
data_bag('databases').each do |database_item|

  # Load the data bag item
  database = data_bag_item('databases', database_item)

  # Create the database if it doesn't exist yet
  # todo Change this to a bash script?
  execute "create_database_#{database[:name]}" do
    command "mysql -u root -p\"#{root_user[:password]}\" -e \"" \
              "CREATE DATABASE IF NOT EXISTS #{database[:name]} DEFAULT CHARACTER SET #{database[:character_set]} COLLATE #{database[:collation]};\"" \
            ' && ' \
            "touch #{Chef::Config[:olyn_application_data_path]}/lock/olyn_database.create_database_#{database[:name]}.lock"
    creates "#{Chef::Config[:olyn_application_data_path]}/lock/olyn_database.create_database_#{database[:name]}.lock"
    action :run
    only_if { local_server[:bootstrapper] }
    sensitive true
  end

  # A full path to the database import SQL file
  import_sql_file_path = database[:import_sql_file].nil? ? nil : "#{Chef::Config[:olyn_provision_path]}/#{database[:import_sql_file]}"

  # Import the SQL file if it exists
  # todo Change this to a bash script?
  execute "import_database_#{database[:name]}" do
    command "mysql -u root -p\"#{root_user[:password]}\" #{database[:name]} < #{import_sql_file_path}" \
            ' && ' \
            "touch #{Chef::Config[:olyn_application_data_path]}/lock/olyn_database.import_database_#{database[:name]}.lock"
    creates "#{Chef::Config[:olyn_application_data_path]}/lock/olyn_database.import_database_#{database[:name]}.lock"
    action :run
    not_if { database[:import_sql_file].nil? }
    only_if { File.exist?(import_sql_file_path) }
    only_if { local_server[:bootstrapper] }
    sensitive true
  end

  # Now remove the original SQL files
  file import_sql_file_path do
    action :delete
    not_if { database[:import_sql_file].nil? }
    only_if { File.exist?(import_sql_file_path) }
  end
end
