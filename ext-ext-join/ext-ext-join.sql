USE [ExternalTablesTestDB];

SELECT TOP 10 s.[Order ID], p.id, s.Region, s.Country, s.[Total Profit], p.firstName, p.lastName
FROM sales_records_5k_parquet AS s
JOIN people_10m_parquetsnappy AS p
ON (s.[Order ID] = p.id);
