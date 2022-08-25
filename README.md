# Testing SQL Server + MinIO integration scenarios

## 1. Backup and restore

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

## 2. Basic access to external tables

### Pre-requisites: Install polybase feature

Ref to install the required packages:
https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-linux-setup?view=sql-server-ver16

Ref to enable the feature: https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-configure-s3-compatible?view=sql-server-ver16#pre-configuration

Run common actions (create credentials, etc) from `common.sql`

Then switch to `external-table-query` dir.

#### Enable polybase export for allowing data to be written on external sources

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
### Define an external table and query it

External table is stored in MinIO.

#### CSV

Source data:

``` shell
$ mc cat --insecure mdc/sql-data/csv/Heroes.csv
First_Name,Last_Name,Company,Grade
Peter,Parker,Marvel,A
Bruce,Wayne ,DC,A+
Tony,Stark,Marvel,B
Steve,Rogers,Marvel,B+
James,Howlett,Marvel,A+
$ mc cp --insecure mdc/sql-data/csv/Heroes.csv play/sqltest/
```

Run `csv-external.sql` - create external file format for CSV. 

### Parquet

#### Source data 1:

``` shell
mc cp --insecure mdc/sql-data/parquet/SalesRecords5kk.parquet .

$ parquet-tool head -n1 SalesRecords5kk.parquet 
Region = Australia and Oceania
Country = Palau
Item Type = Office Supplies
Sales Channel = Online
Order Priority = H
Order Date = 2016-03-06
Ship Date = 2016-03-26
Units Sold = 2401
Unit Price = 651.2100219726562
Unit Cost = 524.9600219726562
Total Revenue = 1.56355525e+06
Total Cost = 1.260429e+06
Total Profit = 303126.25
Order ID = 40000

$ parquet-tool schema SalesRecords5kk.parquet 
message schema {
  optional binary Region (STRING);
  optional binary Country (STRING);
  optional binary Item Type (STRING);
  optional binary Sales Channel (STRING);
  optional binary Order Priority (STRING);
  optional binary Order Date (STRING);
  optional binary Ship Date (STRING);
  optional int64 Units Sold;
  optional double Unit Price;
  optional double Unit Cost;
  optional double Total Revenue;
  optional double Total Cost;
  optional double Total Profit;
  optional int64 Order ID;
}

$ mc cp --insecure mdc/sql-data/parquet/SalesRecords5kk.parquet play/sqltest/

```

The first half of the commands in `parquet-external.sql` use the data above.

### Source data 2 (multiple parquet files):

Copy this data to play (after unzipping).

``` shell
mc ls --insecure mdc/sql-data/people-10m.zip
[2022-08-03 14:37:35 PDT] 170MiB STANDARD people-10m.zip

# After copying to play:
$ mc ls play/sqltest/people-10m
[2022-08-22 13:36:58 PDT]  57MiB STANDARD part-00000-fc28a224-52a8-4eba-bf48-644536d356fc-c000.snappy.parquet
[2022-08-22 13:36:58 PDT]  56MiB STANDARD part-00001-65044aa7-0a61-40b3-bbeb-e02964774d66-c000.snappy.parquet
[2022-08-22 13:36:58 PDT]  57MiB STANDARD part-00002-c1f78f22-8fc3-4ad7-9e14-89b530585341-c000.snappy.parquet
[2022-08-22 13:36:58 PDT]  56MiB STANDARD part-00003-bba3afa9-da46-4769-a312-b70a256eef36-c000.snappy.parquet

```

The second half of the commands in `parquet-external.sql` use the data above.

## 3. Join of external table with internal table

Here we will attempt to join with the `people-10m` dataset.

See `internal-external-join/int-ext-join.sql`

## 4. Join of external table with external table

Just for demonstration we attempt to join `sales_records_5k_parquet` with `people_10m_parquetsnappy` - the query itself is meaningless.

See `ext-ext-join/ext-ext-join.sql`

## 5. OpenRowSet

See `openrowset-select/openrowset.sql`

## 6. OpenRowSet CETAS

See `openrowset-cetas/cetas.sql`.
