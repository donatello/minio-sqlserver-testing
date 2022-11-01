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
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'somesecret!';

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

DROP EXTERNAL TABLE sales_records_5k_parquet;
CREATE EXTERNAL TABLE sales_records_5k_parquet(
          Region VARCHAR(80),
          Country VARCHAR(80),
          [Item Type] VARCHAR(30),
          [Sales Channel] VARCHAR(30),
          [Order Priority] VARCHAR(30),
          [Order Date] VARCHAR(20),
          [Ship Date] VARCHAR(20),
          [Units Sold] BIGINT,
          [Unit Price] FLOAT,
          [Unit Cost] FLOAT,
          [Total Revenue] FLOAT,
          [Total Cost] FLOAT,
          [Total Profit] FLOAT,
          [Order ID] BIGINT
    )
    WITH (
      LOCATION = '/sqltest/SalesRecords5kk.parquet',
      DATA_SOURCE = minio_dc,
      FILE_FORMAT = ParquetFileFormat
    )
;
SELECT TOP 1 * FROM sales_records_5k_parquet;

