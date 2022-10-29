USE [ExternalTablesTestDB];

-- 1. Define our file format.
--    NOTE: Skips header line
CREATE EXTERNAL FILE FORMAT csv1
WITH (FORMAT_TYPE = DELIMITEDTEXT,
      FORMAT_OPTIONS(
          FIELD_TERMINATOR = ',',
          STRING_DELIMITER = '"',
          FIRST_ROW = 2,
          USE_TYPE_DEFAULT = True)
)

-- 2. Create external table using our previously defined data source.
CREATE EXTERNAL TABLE heroes_csv (
    first_name varchar(50),
    last_name varchar(50),
    company varchar(50),
    grade varchar(10)
)
WITH (
        LOCATION='/sqltest/Heroes.csv',
        DATA_SOURCE = minio_dc,
        FILE_FORMAT = csv1
    )
;

-- 3. Display contents
SELECT * FROM heroes_csv;
