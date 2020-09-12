# Add Percona repo
include_recipe 'olyn_percona::repo'

# Include the main install recipe
include_recipe 'olyn_percona::install'

# Cluster bootstrap routines if applicable
include_recipe 'olyn_percona::bootstrap'

# Secure local MySQL install and set root password
include_recipe 'olyn_percona::security'

# Configure databases
include_recipe 'olyn_percona::databases'

# Configure users
include_recipe 'olyn_percona::users'
