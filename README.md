Olyn Percona Recipe

### SSL Certificate Configuration

This package uses SSL certificates to encrypt all client and server traffic.
MySQL automatically creates all of the certificates needed on initial install.
However each node must be using the same cert files for encryption to work.

To facilitate this the cert files are distributed with the package via encrypted data bag.
First, install the package on the bootstrapper.
Then import the following certs into the the "ssl_certificates" data bag:

#### Data bag: `ssl_certificates/percona_server.json`
Certificate authority:  `/etc/mysql/certs/ca.pem`  
Server cert: `/etc/mysql/certs/server-cert.pem`  
Server private key: `/etc/mysql/certs/server-key.pem`

#### Data bag: `ssl_certificates/percona_client.json`
Certificate authority: `/etc/mysql/certs/ca.pem`  
Client cert:` /etc/mysql/certs/client-cert.pem`  
Client private key: `/etc/mysql/certs/client-key.pem`

### Importing SQL files
Percona requires a certain SQL format to import properly. To Properly prepare an export from an existing database into Percona the command is:

    mysqldump -u root -p"ROOT_PASSWORD" --single-transaction --master-data --skip-add-locks --routines --triggers DATABASENAME > /path/to/export.sql

### Conflicts With Existing Packages
This package will check for and remove the following packages before install:

`mariadb-common`  
`mysql-common`  

`mailutils` is commonly installed on VPS base images and will install these as dependencies.

### Using DebConf to automate answers to graphical installer
The Percona installer is graphical and requires user input.
This cookbook automates answers to the graphical installer using a seed file.
If the questions change, you can see all of the input choices for the graphical installer with debconf:

    debconf-get-selections |grep 'percona'

Update the seed file in this package accordingly.
