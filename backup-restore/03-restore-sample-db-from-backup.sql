-- Restore script

USE master;
GO

-- Delete the local db first, to restore it again from backup
DROP DATABASE IF EXISTS [SQLTestDB];
GO

-- Restore
RESTORE DATABASE [SQLTestDB]
FROM    URL = 's3://15.15.15.185:9000/sqltest/sqltestdb_01.bak'
WITH    REPLACE -- overwrite
,       STATS               = 10;
GO

-- Switch to restored db and show some contents.
USE [SQLTestDB];
GO

SELECT * FROM SQLTest;
GO
