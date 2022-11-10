-- Credential for MinIO
DROP CREDENTIAL [s3://15.15.15.185:9000/sqltest];

CREATE CREDENTIAL   [s3://15.15.15.185:9000/sqltest]
WITH
        IDENTITY    = 'S3 Access Key',
        SECRET      = 'minio:minio321';


-- Backup command for the test db.
BACKUP DATABASE [SQLTestDB]
TO      URL = 's3://15.15.15.185:9000/sqltest/sqltestdb_01.bak'
WITH    FORMAT -- overwrite
,       STATS               = 10
,       COMPRESSION;
