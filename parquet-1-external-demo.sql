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

-- Multiple same-schema parquet files:

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
     LOCATION = '/sqltest/people-10m/',
     DATA_SOURCE = minio_dc,
     FILE_FORMAT = ParquetFormatWithSnappy
   )
;

-- SAMPLE queries to try
SELECT TOP 3 * FROM people_10m_parquetsnappy;
SELECT * FROM people_10m_parquetsnappy WHERE salary > 150000;
