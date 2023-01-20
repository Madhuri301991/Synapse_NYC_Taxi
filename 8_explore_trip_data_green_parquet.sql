USE nyc_taxi_discovery;

-- This is auto-generated code
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://coursesynapsedatalake.dfs.core.windows.net/nyc-taxi-data/raw/trip_data_green_parquet/year=2020/month=01/part-00000-tid-6133789922049958496-2e489315-890a-4453-ae93-a104be9a6f06-106-1-c000.snappy.parquet',
        FORMAT = 'PARQUET'
    ) AS [result]

-- No need of parser_version and header specification in parquet file
-- Use external data source 

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/part-00000-tid-6133789922049958496-2e489315-890a-4453-ae93-a104be9a6f06-106-1-c000.snappy.parquet',
        FORMAT = 'PARQUET',
        DATA_SOURCE='nyc_taxi_data_ext_raw'
    ) AS [result]

-- Remove parquet file name and read all file within that folder 

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        FORMAT = 'PARQUET',
        DATA_SOURCE='nyc_taxi_data_ext_raw'
    ) AS [result]


-- Identify the inferred data types 


EXEC sp_describe_first_result_set N'
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK ''trip_data_green_parquet/year=2020/month=01/'',
        FORMAT = ''PARQUET'',
        DATA_SOURCE=''nyc_taxi_data_ext_raw''
    ) AS [result]'

-- Define the column and data types 

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        FORMAT = 'PARQUET',
        DATA_SOURCE='nyc_taxi_data_ext_raw'
    ) 
WITH (
    VendorID INT,
    lpep_pickup_datetime datetime2(7),
    lpep_dropoff_datetime datetime2(7),
    store_and_fwd_flag CHAR(1),
    RatecodeID INT, 
    PULocationID INT,
    DOLocationID INT, 
    passenger_count INT, 
    trip_distance FLOAT,
    fare_amount FLOAT, 
    extra FLOAT, 
    mta_tax FLOAT, 
    tip_amount FLOAT, 
    tolls_amount FLOAT, 
    ehail_fee INT,
    improvement_surcharge FLOAT,
    total_amount FLOAT,
    payment_type INT, 
    trip_type INT, 
    congestion_surcharge FLOAT
) AS [result]

-- Selecting only the required columns 

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        FORMAT = 'PARQUET',
        DATA_SOURCE='nyc_taxi_data_ext_raw'
    ) 
WITH (
    tip_amount FLOAT,
    trip_type INT
) AS [result]

/*
1] query from folders using wildcard characters
2] use filename function 
3] query from subfolders 
4] use filepath function to select only from certain partitions 
*/

--1] query from folders using wildcard characters

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/*.parquet',
        FORMAT = 'PARQUET',
        DATA_SOURCE='nyc_taxi_data_ext_raw'
    ) AS trip_data

--2] Get filename

SELECT
    TOP 100 
    trip_data.filename() as file_name,
    trip_data.*
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/*.parquet',
        FORMAT = 'PARQUET',
        DATA_SOURCE='nyc_taxi_data_ext_raw'
    ) AS trip_data

-- 3] Query from sub folders 

SELECT
    TOP 100 
    trip_data.filepath() as file_path,
    trip_data.*
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/**',
        FORMAT = 'PARQUET',
        DATA_SOURCE='nyc_taxi_data_ext_raw'
    ) AS trip_data

-- 4] Use filepath to target partitions 

SELECT
    trip_data.filepath(1) as year,      
    trip_data.filepath(2) as month,      
    count(1) as record_count
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=*/month=*/*.parquet',
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT = 'PARQUET'
    ) AS trip_data
WHERE trip_data.filepath(1)='2020' AND trip_data.filepath(2) IN ('06','07','08')
GROUP BY trip_data.filepath(1),trip_data.filepath(2)
ORDER BY trip_data.filepath(1),trip_data.filepath(2);
