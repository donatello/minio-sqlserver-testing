-- Switch to master db
USE master;

-- Delete the test db
DROP DATABASE IF EXISTS [MinIOTestDB];

-- Create the test db
CREATE DATABASE [MinIOTestDB];

-- Execute all the above immediately
GO

-- switch to created DB
USE [MinIOTestDB];

-- Create a master key for encrypting database scoped credentials.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'somesecret123!';

-- Create minio credential (Play server)
CREATE DATABASE SCOPED CREDENTIAL minio_dc_cred
WITH IDENTITY = 'S3 Access Key'
     , SECRET = 'minio:minio321' ;

-- Create minio data source starting at a bucket
CREATE EXTERNAL DATA SOURCE minio_dc
WITH
(   LOCATION = 's3://15.15.15.185:9000/'
,   CREDENTIAL = minio_dc_cred
);

-- 1. Define our file format.
--    NOTE: Skips header line
CREATE EXTERNAL FILE FORMAT csv1
WITH (FORMAT_TYPE = DELIMITEDTEXT,
      FORMAT_OPTIONS(
          FIELD_TERMINATOR = ',',
          STRING_DELIMITER = '"',
          FIRST_ROW = 2,
          USE_TYPE_DEFAULT = True)
)

-- 2. Create external table using our previously defined data source.
CREATE EXTERNAL TABLE heroes_csv (
    first_name varchar(50),
    last_name varchar(50),
    company varchar(50),
    grade varchar(10)
)
WITH (
        LOCATION='/sqltest/Heroes.csv',
        DATA_SOURCE = minio_dc,
        FILE_FORMAT = csv1
    )
;

-- 3. Display contents
SELECT * FROM heroes_csv;
