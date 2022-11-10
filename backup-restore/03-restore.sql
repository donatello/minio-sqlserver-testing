-- Restore script

-- Delete the local db first, to restore it again from backup
DROP DATABASE [SQLTestDB];

RESTORE DATABASE [SQLTestDB]
FROM    URL = 's3://15.15.15.185:9000/sqltest/sqltestdb_01.bak'
WITH    REPLACE -- overwrite
,       STATS               = 10;
