USE nyc_taxi_ldw
GO

-- create view for trip_data_green  --> because external table cannot be created on partition
-- data in this view comes from partition column that exist gold folder

DROP view IF EXISTS gold.vw_trip_data_green
GO

CREATE view gold.vw_trip_data_green
AS
SELECT
    result.filepath(1) AS year,
    result.filepath(2) AS month,
    result.*
FROM
    OPENROWSET(
        BULK 'gold/trip_data_green/year=*/month=*/*.parquet',
        DATA_SOURCE='nyc_taxi_ext_data_src',
	    FORMAT = 'PARQUET'
    ) 
    WITH (
        borough VARCHAR(15),
        trip_date DATE,
        trip_day VARCHAR(10),
        trip_day_weekend_ind CHAR(1),
        card_trip_count INT,
        cash_trip_count INT,
        street_hail_trip_count INT,
        dispatch_trip_count INT,
        trip_distance FLOAT,
        trip_duration INT,
        fare_amount FLOAT
    ) AS [result]
GO


SELECT TOP(100) * FROM gold.vw_trip_data_green
Go
