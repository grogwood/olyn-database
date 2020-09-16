Olyn Database Recipe

### Importing SQL files
To Properly prepare an export from an existing database into a flat file the command is:

    mysqldump -u root -p"ROOT_PASSWORD" --single-transaction --master-data --skip-add-locks --routines --triggers DATABASENAME > /path/to/export.sql
