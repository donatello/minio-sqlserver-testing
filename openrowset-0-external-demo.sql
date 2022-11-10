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

GO

SELECT TOP 10 [cc].Region, [cc]."Total Cost", [cc]."Total Profit"
FROM OPENROWSET
     ( BULK '/sqldemo2/SalesRecords5kk.parquet'
     , FORMAT = 'PARQUET'
     , DATA_SOURCE = 'minio_dc'
     ) AS [cc];


