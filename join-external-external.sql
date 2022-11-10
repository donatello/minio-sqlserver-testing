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


-- Setup external table for people-10m data

CREATE EXTERNAL FILE FORMAT ParquetFormatWithSnappy WITH (
       FORMAT_TYPE = PARQUET
       , DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
       )
;

CREATE EXTERNAL TABLE people_10m_parquetsnappy (
      id INT,
      firstName VARCHAR(40),
      middleName VARCHAR(30),
      lastName VARCHAR(30),
      gender VARCHAR(10),
      birthDate DATETIME2,
      ssn VARCHAR(20),
      salary INT
   )
   WITH (
     LOCATION = '/sqldemo2/people-10m/',
     DATA_SOURCE = minio_dc,
     FILE_FORMAT = ParquetFormatWithSnappy
   )
;
-- Check that we can read people-10m data
SELECT TOP 3 * FROM people_10m_parquetsnappy;

-- Setup external table for sales records data

CREATE EXTERNAL FILE FORMAT ParquetFileFormat WITH(FORMAT_TYPE = PARQUET);

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
      LOCATION = '/sqldemo2/SalesRecords5kk.parquet',
      DATA_SOURCE = minio_dc,
      FILE_FORMAT = ParquetFileFormat
    )
;

SELECT TOP 3 * FROM sales_records_5k_parquet;


-- JOIN QUERY

-- This is just a demo query to show that external table join is possible - not
-- much semantic meaning here.
SELECT TOP 10 s.[Order ID], p.id, s.Region, s.Country, s.[Total Profit], p.firstName, p.lastName
FROM sales_records_5k_parquet AS s
JOIN people_10m_parquetsnappy AS p
ON (s.[Order ID] = p.id);
