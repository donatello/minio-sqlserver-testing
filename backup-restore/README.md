# Backup and restore

Using MinIO Play server

Run each script by specifying the script file path in the `sqlcmd` command like so:

``` shell
sqlcmd -S localhost -U sa -i cred.sql -P $SECRET
```

1. Run `sample-db.sql` - create a sample db.
2. Run `cred.sql` - create MinIO credential in SQL server
3. Run `backup.sql` - create a backup.
4. Run `restore.sql` - delete the existing db and restore from backup.

