USE [ExternalTablesTestDB];

CREATE EXTERNAL TABLE computed_table
WITH
( LOCATION = '/sqltest/join_result/computed_table.parquet',
  DATA_SOURCE = minio_play,
  FILE_FORMAT = ParquetFileFormat
)
AS SELECT *
FROM OPENROWSET
     ( BULK '/sqltest/people-10m/'
     , FORMAT = 'PARQUET'
     , DATA_SOURCE = 'minio_play'
     ) AS [cc];



CREATE EXTERNAL TABLE darleens
WITH
( LOCATION = '/sqltest/darleens.csv',
  DATA_SOURCE = minio_play,
  FILE_FORMAT = csv1
)
AS
SELECT *
FROM OPENROWSET
     ( BULK '/sqltest/people-10m/'
     , FORMAT = 'PARQUET'
     , DATA_SOURCE = 'minio_play'
     ) AS [cc]
where firstName = 'Darleen';

