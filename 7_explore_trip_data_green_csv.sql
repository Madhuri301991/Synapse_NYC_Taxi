USE nyc_taxi_discovery;


-- This is auto-generated code

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=2020/month=01/green_tripdata_2020-01.csv',
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE
    ) AS [result]


---- SELECT DATA FROM A FOLDER 

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=2020/month=01/*.csv',   --select data from all .csv files only
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE
    ) AS [result]

--- SELECT DATA FROM Sub folders 

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=2020/**',   -- ** to get data from sub-folders recursively
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE
    ) AS [result]

-- Get Data from more than one file - from January and March

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK ('trip_data_green_csv/year=2020/month=01/*.csv',
        'trip_data_green_csv/year=2020/month=03/*.csv'),
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE
    ) AS [result]


-- Use more than one wildcard character - get only .csv files from all years and all months 

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK ('trip_data_green_csv/year=*/month=*/*.csv'),
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE
    ) AS [result]


-- File metadata function filename()

SELECT
    Top 100 
    result.filename() as filename, 
    result.*
FROM
    OPENROWSET(
        BULK ('trip_data_green_csv/year=*/month=*/*.csv'),
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE
    ) AS [result]

-- Find no of records in each file 

SELECT
    result.filename() as filename, 
    count(1) as record_count
FROM
    OPENROWSET(
        BULK ('trip_data_green_csv/year=*/month=*/*.csv'),
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE
    ) AS [result]
GROUP BY result.filename()
ORDER BY result.filename();

-- LIMIT data using filename()

SELECT
    result.filename() as filename, 
    count(1) as record_count
FROM
    OPENROWSET(
        BULK ('trip_data_green_csv/year=*/month=*/*.csv'),
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE
    ) AS [result]
where result.filename() IN ('green_tripdata_2020-01.csv','green_tripdata_2021-01.csv')
GROUP BY result.filename()
ORDER BY result.filename();


-- Use filepath function 

SELECT
    result.filename() as filename, 
    result.filepath(1) as year,      -- points to first * in the bulk
    result.filepath(2) as month,     -- points to second * in the bulk 
    count(1) as record_count
FROM
    OPENROWSET(
        BULK ('trip_data_green_csv/year=*/month=*/*.csv'),
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE
    ) AS [result]
where result.filename() IN ('green_tripdata_2020-01.csv','green_tripdata_2021-01.csv')
GROUP BY result.filename(),result.filepath(1),result.filepath(2)
ORDER BY result.filename(),result.filepath(1),result.filepath(2);

---------count of each records in year and month

SELECT
    result.filepath(1) as year,      
    result.filepath(2) as month,      
    count(1) as record_count
FROM
    OPENROWSET(
        BULK ('trip_data_green_csv/year=*/month=*/*.csv'),
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE
    ) AS [result]
GROUP BY result.filepath(1),result.filepath(2)
ORDER BY result.filepath(1),result.filepath(2);

--- Use filepath in the where clause

SELECT
    result.filepath(1) as year,      
    result.filepath(2) as month,      
    count(1) as record_count
FROM
    OPENROWSET(
        BULK ('trip_data_green_csv/year=*/month=*/*.csv'),
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE
    ) AS [result]
WHERE result.filepath(1)='2020' AND result.filepath(2) IN ('06','07','08')
GROUP BY result.filepath(1),result.filepath(2)
ORDER BY result.filepath(1),result.filepath(2);



