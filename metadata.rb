name 'olyn_database'
maintainer 'Scott Richardson'
maintainer_email 'dev@grogwood.com'
chef_version '~> 16'
license 'GPL-3.0'
supports 'debian', '>= 10'
source_url 'https://gitlab.com/olyn/olyn_database'
description 'Configures and imports databases and database users from data bag items'
version '1.0.1'

provides 'olyn_database::default'
provides 'olyn_database::databases'
provides 'olyn_database::users'
recipe 'olyn_database::default', 'Creates databases, imports data, and creates database users'
recipe 'olyn_database::databases', 'Creates and imports databases'
recipe 'olyn_database::users', 'Creates database users'
