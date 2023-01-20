USE nyc_taxi_discovery;

-- Retrieve the records from delta tab 

SELECT TOP 100 *
FROM OPENROWSET (
        BULK 'trip_data_green_delta/',    --for delta file query the folder, no ability to query the individual file 
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT='DELTA'
) AS trip_data                             -- delta table takes partition value year and month and turns them into columns


-- Check the datatype of column

EXEC sp_describe_first_result_set N'
SELECT TOP 100 *
FROM OPENROWSET (
        BULK ''trip_data_green_delta/'',   
        DATA_SOURCE=''nyc_taxi_data_ext_raw'',
        FORMAT=''DELTA''
) AS trip_data'

--- Specify the column 

SELECT TOP 100 *
FROM OPENROWSET (
        BULK 'trip_data_green_delta/',     
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT='DELTA'
) 
with (
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
    congestion_surcharge FLOAT,
    year VARCHAR(4),    --partition folder created as a column
    month VARCHAR(2)    --partition folder created as a column
)AS trip_data; 

-- select only the required column 

SELECT TOP 100 *
FROM OPENROWSET (
        BULK 'trip_data_green_delta/',     
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT='DELTA'
) 
with (
    tip_amount FLOAT,
    trip_type INT, 
    year VARCHAR(4),    --specify partition columns year and month compulsory, else you will get error 
    month VARCHAR(2)    
)AS trip_data; 

------------------------------------------------------------------

SELECT COUNT(DISTINCT payment_type)
FROM OPENROWSET (
        BULK 'trip_data_green_delta/',     
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT='DELTA'
) AS trip_data;


---------------------------------------------------------------------


SELECT COUNT(DISTINCT payment_type)
FROM OPENROWSET (
        BULK 'trip_data_green_delta/',     
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT='DELTA'
) AS trip_data
where year='2020' AND month='01';