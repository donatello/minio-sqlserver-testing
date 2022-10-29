-- Create a database for the tests.
CREATE DATABASE [ExternalTablesTestDB];

USE [ExternalTablesTestDB];

-- Create a master key for encrypting database scoped credentials.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '0bjectst0rage!';

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
