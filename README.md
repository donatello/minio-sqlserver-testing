# Testing SQL Server + MinIO integration scenarios

## Demo

### Drop a file into a bucket and read data via external tables

NOTE: Shell commands are run from `C:\Users\Administrators\Downloads` as this is where `mc.exe` is present.

1. Setup steps

``` shell

# Copy data into bucket for sqlserver
mc.exe cp -r dcminio/datasets/people-10m/ dcminio/sqltest/people-10m/
```

2. Show demo script `parquet-1-external-demo.sql`

3. Cleanup steps

``` shell

# Remove the data from dcminio/sqltest/ for cleanup
mc.exe rm -r --force dcminio/sqltest/people-10m

```

### Move data into MinIO

The purpose is to recover disk space on SQLServer when tables get large.

1. Show demo script `move-heroes-demo.sql`


## External table feature demos

Please see the scripts at the top level, ending with `-demo.sql`.

Each script is self contained and starts of by deleting the database if it exists, before creating and using it.

## Backup and restore demo

Switch to `backup-restore` dir.

Ref: https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/sql-server-backup-to-url-s3-compatible-object-storage?view=sql-server-ver16

Using MinIO Play server

Run each script by specifying the script file path in the `sqlcmd` command like so:

``` shell
sqlcmd -S 15.15.15.105 -U sa -i cred.sql -P $SECRET
```

1. Run `sample-db.sql` - create a sample db.
2. Run `cred.sql` - create MinIO credential in SQL server
3. Run `backup.sql` - create a backup.
4. Run `restore.sql` - delete the existing db and restore from backup.

## Appendix

### Pre-requisites: Install polybase feature

Ref to install the required packages:
https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-linux-setup?view=sql-server-ver16

Ref to enable the feature: https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-configure-s3-compatible?view=sql-server-ver16#pre-configuration

Run common actions (create credentials, etc) from `common.sql`

Then switch to `external-table-query` dir.

### Enable polybase export for allowing data to be written on external sources

https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/allow-polybase-export?view=sql-server-ver16

``` shell
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'allow polybase export', 1;
GO
RECONFIGURE;
GO
```

