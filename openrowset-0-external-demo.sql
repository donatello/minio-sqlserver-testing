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

GO

SELECT TOP 10 [cc].firstName, [cc].lastName
FROM OPENROWSET
     ( BULK '/sqltest/people-10m/'
     , FORMAT = 'PARQUET'
     , DATA_SOURCE = 'minio_dc'
     ) AS [cc];

SELECT *
FROM OPENROWSET
     ( BULK '/sqltest/Heroes.csv'
     , FORMAT = 'CSV'
     , DATA_SOURCE = 'minio_dc'
     , FIRSTROW = 2
     )
WITH ( First_Name VARCHAR(15),
       Last_Name  VARCHAR(15),
       Company  VARCHAR(15),
       Grade  VARCHAR(4)
     )
     AS [cc];
