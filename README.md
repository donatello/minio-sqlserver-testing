# Testing SQL Server + MinIO integration scenarios

## Speaking Demos

### Drop a file into a bucket and read data via external tables

NOTE: Shell commands are run from `C:\Users\Administrators\Downloads` as this is where `mc.exe` is present.

1. Setup steps

``` shell

# Copy data into bucket for sqlserver
mc.exe cp -r dcmin/datasets/people-10m/ dcmin/sqltest/people-10m/
```

2. Show demo script [`parquet-1-external-demo.sql`](/parquet-1-external-demo.sql)

3. Cleanup steps

``` shell

# Remove the data from dcmin/sqltest/ for cleanup
mc.exe rm -r --force dcmin/sqltest/people-10m

```

### Move data into MinIO

The purpose is to recover disk space on SQLServer when tables get large.

1. Show demo script [`move-heroes-demo.sql`](/move-heroes-demo.sql)

2. Show that file now exists in MinIO

``` shell
mc.exe ls dcmin/sqltest/heroes.csv
mc.exe cat dcmin/sqltest/heroes.csv/<filename>

```

3. Cleanup

``` shell
mc.exe rm -r --force dcmin/sqltest/heroes.csv
```

## Floor Demos

1. Backup-Restore Demo: Use the scripts in the [`backup-restore`](/backup-restore) directory in order.
   Ref: https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/sql-server-backup-to-url-s3-compatible-object-storage?view=sql-server-ver16
2. Access external data with OpenRowSet:
   1. Read a parquet file - [`openrowset-0-external-demo.sql`](/openrowset-0-external-demo.sql)
   2. Read a CSV file - [`openrowset-1-external-demo.sql`](/openrowset-1-external-demo.sql)
3. Access external data with an External Table
   1. Read a parquet file - [`parquet-0-external-demo.sql`](/parquet-0-external-demo.sql)
4. Create External Table from SQLServer (write tables to MinIO)

   NOTE: Delete the outputs directory with `mc.exe rm -r --force dcmin/sqldemo2/cetas-outputs` before the demo.

   1. Copy an internal table into MinIO - [`cetas-0-external-demo.sql`](/cetas-0-external-demo.sql)
   2. Process an external table and write results into MinIO - [`cetas-1-external-demo.sql`](/cetas-1-external-demo.sql)
5. Join internal and external table - [`join-internal-external.sql`](/join-internal-external.sql)
6. Join external and external table - [`join-external-external.sql`](/join-external-external.sql)


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

