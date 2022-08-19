DROP DATABASE [SQLTestDB];

RESTORE DATABASE [SQLTestDB]
FROM    URL = 's3://play.min.io/sqltest/sqltestdb_01.bak'
WITH    REPLACE -- overwrite
,       STATS               = 10;
