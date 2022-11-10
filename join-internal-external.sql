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


-- Create a local table with some data.
--
-- We are going join and find total pay for people in the extra_pay table.
CREATE TABLE extra_pay (
    ssn VARCHAR(20),
    amount INT
);

-- Sample rows from people-10m chosen to join on:
--    8406459 Fabian          Santo       Coppeard       M    1958-04-06 05:00:00.0000000 923-77-6829 152383
--    8418281 Pedro           Dannie      Prangnell      M    1958-05-09 04:00:00.0000000 988-78-6786 152071
--    8425363 Ismael          Casey       Vince          M    1974-02-03 04:00:00.0000000 948-31-9709 162390
--    8425790 Odell           Stacey      Lonie          M    1999-12-25 05:00:00.0000000 930-80-8712 151811
--    8471972 Ted             Kenton      Chieco         M    1970-06-13 04:00:00.0000000 930-79-5875 162526
--    8526208 Alfonso         Renaldo     Ardern         M    1988-01-28 05:00:00.0000000 989-68-4118 159485
--    8550810 Luke            Jerome      Arkow          M    1966-06-21 04:00:00.0000000 989-63-7512 151531
--    8607222 Alton           Preston     Kyte           M    1992-03-26 05:00:00.0000000 978-66-9726 157167

INSERT INTO extra_pay (ssn, amount)
VALUES   ('923-77-6829', 100000),
         ('988-78-6786', 100000),
         ('948-31-9709', 100000),
         ('930-80-8712', 100000),
         ('930-79-5875', 100000),
         ('989-68-4118', 100000),
         ('989-63-7512', 100000),
         ('978-66-9726', 100000);

-- This query works. It returns more than 8 results because the original dataset
-- has people with duplicate SSNs.
SELECT p.firstName, p.middleName, p.lastName, e.ssn,p.ssn, e.amount + p.salary AS total
FROM extra_pay AS e JOIN people_10m_parquetsnappy AS p ON (p.ssn = e.ssn)
ORDER BY p.ssn;
