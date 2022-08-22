USE [ExternalTablesTestDB];

SELECT TOP 10 [cc].firstName, [cc].lastName
FROM OPENROWSET
     ( BULK '/sqltest/people-10m/'
     , FORMAT = 'PARQUET'
     , DATA_SOURCE = 'minio_play'
     ) AS [cc];

SELECT *
FROM OPENROWSET
     ( BULK '/sqltest/Heroes.csv'
     , FORMAT = 'CSV'
     , DATA_SOURCE = 'minio_play'
     , FIRSTROW = 2
     )
WITH ( First_Name VARCHAR(15),
       Last_Name  VARCHAR(15),
       Company  VARCHAR(15),
       Grade  VARCHAR(4)
     )
