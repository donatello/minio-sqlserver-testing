-- Switch to master db
USE master;

-- Delete the test db
DROP DATABASE [MinIOTestDB];

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

CREATE EXTERNAL FILE FORMAT ParquetFileFormat WITH(FORMAT_TYPE = PARQUET);

CREATE EXTERNAL FILE FORMAT csv1
WITH (FORMAT_TYPE = DELIMITEDTEXT,
      FORMAT_OPTIONS(
          FIELD_TERMINATOR = ',',
          STRING_DELIMITER = '"',
          FIRST_ROW = 2,
          USE_TYPE_DEFAULT = True)
)

-- create a table stored on MinIO in parquet format at given location.
CREATE EXTERNAL TABLE computed_table
WITH
( LOCATION = '/sqltest/join_result/computed_table.parquet',
  DATA_SOURCE = minio_dc,
  FILE_FORMAT = ParquetFileFormat
)
AS SELECT *
FROM OPENROWSET
     ( BULK '/sqltest/people-10m/'
     , FORMAT = 'PARQUET'
     , DATA_SOURCE = 'minio_dc'
     ) AS [cc];


-- create a table stored on MinIO in csv format at given location.
CREATE EXTERNAL TABLE darleens
WITH
( LOCATION = '/sqltest/darleens.csv',
  DATA_SOURCE = minio_dc,
  FILE_FORMAT = csv1
)
AS
SELECT *
FROM OPENROWSET
     ( BULK '/sqltest/people-10m/'
     , FORMAT = 'PARQUET'
     , DATA_SOURCE = 'minio_dc'
     ) AS [cc]
where firstName = 'Darleen';
