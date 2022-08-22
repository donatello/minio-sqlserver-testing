-- Create a database for the tests.
CREATE DATABASE [ExternalTablesTestDB];

USE [ExternalTablesTestDB];

-- Create a master key for encrypting database scoped credentials.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '0bjectst0rage!';

-- Create minio credential (Play server)
CREATE DATABASE SCOPED CREDENTIAL minio_play_cred
WITH IDENTITY = 'S3 Access Key'
     , SECRET = 'Q3AM3UQ867SPQQA43P2F:zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG' ;

-- Create minio data source starting at a bucket
CREATE EXTERNAL DATA SOURCE minio_play
WITH
(   LOCATION = 's3://play.min.io/'
,   CREDENTIAL = minio_play_cred
);
