Olyn Database Recipe

### Importing SQL files
Percona requires a certain SQL format to import properly. To Properly prepare an export from an existing database into Percona the command is:

    mysqldump -u root -p"ROOT_PASSWORD" --single-transaction --master-data --skip-add-locks --routines --triggers DATABASENAME > /path/to/export.sql
