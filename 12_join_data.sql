USE nyc_taxi_discovery;


-- Identify each of the trips made from each borough 

---  Trip table 
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        FORMAT = 'PARQUET',
        DATA_SOURCE='nyc_taxi_data_ext_raw'
    ) AS [result]
where PULocationID is NULL;

--- JOIN query

SELECT taxi_zone.*,trip_data.*
    FROM 
        OPENROWSET(
                    BULK 'trip_data_green_parquet/year=2020/month=01/',
                    FORMAT = 'PARQUET',
                    DATA_SOURCE='nyc_taxi_data_ext_raw'
                  ) AS trip_data
        JOIN
        OPENROWSET(
                    BULK 'taxi_zone.csv',
                    DATA_SOURCE='nyc_taxi_data_ext_raw',
                    FORMAT = 'CSV',
                    PARSER_VERSION = '2.0',
                    HEADER_ROW=TRUE 
                  )
                  WITH 
                  (
                    location_id SMALLINT 1, 
                    borough VARCHAR(15) 2,
                    zone VARCHAR(50) 3,
                    service_zone VARCHAR(15) 4
                  ) AS taxi_zone
        ON trip_data.PULocationID=taxi_zone.location_id;

-- Join query with aggregations


SELECT taxi_zone.borough, COUNT(1) AS number_of_trips
    FROM 
        OPENROWSET(
                    BULK 'trip_data_green_parquet/year=2020/month=01/',
                    FORMAT = 'PARQUET',
                    DATA_SOURCE='nyc_taxi_data_ext_raw'
                  ) AS trip_data
        JOIN
        OPENROWSET(
                    BULK 'taxi_zone.csv',
                    DATA_SOURCE='nyc_taxi_data_ext_raw',
                    FORMAT = 'CSV',
                    PARSER_VERSION = '2.0',
                    HEADER_ROW=TRUE 
                  )
                  WITH 
                  (
                    location_id SMALLINT 1, 
                    borough VARCHAR(15) 2,
                    zone VARCHAR(50) 3,
                    service_zone VARCHAR(15) 4
                  ) AS taxi_zone
        ON trip_data.PULocationID=taxi_zone.location_id
GROUP BY taxi_zone.borough
ORDER BY number_of_trips;
            
        
