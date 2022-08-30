#!/usr/bin/env bash

mc mb play/sqltest
mc cp --insecure mdc/sql-data/csv/Heroes.csv play/sqltest/
mc cp --insecure mdc/sql-data/parquet/SalesRecords5kk.parquet play/sqltest/
mc cp --insecure mdc/sql-data/people-10m.zip /tmp/
unzip /tmp/people-10m.zip -d /tmp/p
mc cp /tmp/p/people-10m/part* play/sqltest/people-10m/
rm -rf /tmp/people-10m.zip /tmp/p
