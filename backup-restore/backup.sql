BACKUP DATABASE [SQLTestDB]
TO      URL = 's3://play.min.io/sqltest/sqltestdb_01.bak'
WITH    FORMAT -- overwrite
,       STATS               = 10
,       COMPRESSION;
