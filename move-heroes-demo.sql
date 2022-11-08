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

-- SETUP steps (create the heroes table in sqlserver)

CREATE TABLE heroes (
    first_name varchar(50),
    last_name varchar(50),
    company varchar(50),
    grade varchar(10)
);

INSERT INTO heroes (first_name, last_name, company, grade)
VALUES ('Peter','Parker','Marvel','A'),
       ('Bruce','Wayne','DC','A+'),
       ('Tony','Stark','Marvel','B'),
       ('Steve','Rogers','Marvel','B+'),
       ('James','Howlett','Marvel','A+');

-- SETUP DONE

-- Show rows in table

SELECT * FROM heroes;

-- SETUP CONNECTIVITY TO MinIO

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


-- Define the CSV file format we want to use for the external table.
CREATE EXTERNAL FILE FORMAT csv1
WITH (FORMAT_TYPE = DELIMITEDTEXT,
      FORMAT_OPTIONS(
          FIELD_TERMINATOR = ',',
          STRING_DELIMITER = '"',
          FIRST_ROW = 2,
          USE_TYPE_DEFAULT = True)
)


-- Copy and move data into MinIO

-- create a table stored on MinIO in csv format at given location.
CREATE EXTERNAL TABLE heroes_csv
WITH
( LOCATION = '/sqltest/heroes.csv',
  DATA_SOURCE = minio_dc,
  FILE_FORMAT = csv1
)
AS
SELECT *
FROM heroes;

-- Remove the local table
DROP TABLE heroes;

-- Read heroes table from MinIO
SELECT * FROM heroes_csv;
