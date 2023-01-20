USE nyc_taxi_discovery;

-- Number of trips made by duration in hours

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        FORMAT = 'PARQUET',
        DATA_SOURCE='nyc_taxi_data_ext_raw'
    ) AS trip_data

-- using datediff

SELECT
    DATEDIFF(minute,lpep_pickup_datetime,lpep_dropoff_datetime)/60 AS from_hour,
    (DATEDIFF(minute,lpep_pickup_datetime,lpep_dropoff_datetime)/60)+1 AS to_hour,
    COUNT(1) AS number_of_trips
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        FORMAT = 'PARQUET',
        DATA_SOURCE='nyc_taxi_data_ext_raw'
    ) AS trip_data
GROUP BY DATEDIFF(minute,lpep_pickup_datetime,lpep_dropoff_datetime)/60,(DATEDIFF(minute,lpep_pickup_datetime,lpep_dropoff_datetime)/60)+1
ORDER BY from_hour,to_hour;

-- Using datediff for all files 

SELECT
    DATEDIFF(minute,lpep_pickup_datetime,lpep_dropoff_datetime)/60 AS from_hour,
    (DATEDIFF(minute,lpep_pickup_datetime,lpep_dropoff_datetime)/60)+1 AS to_hour,
    COUNT(1) AS number_of_trips
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/**',
        FORMAT = 'PARQUET',
        DATA_SOURCE='nyc_taxi_data_ext_raw'
    ) AS trip_data
GROUP BY DATEDIFF(minute,lpep_pickup_datetime,lpep_dropoff_datetime)/60,(DATEDIFF(minute,lpep_pickup_datetime,lpep_dropoff_datetime)/60)+1
ORDER BY from_hour,to_hour;