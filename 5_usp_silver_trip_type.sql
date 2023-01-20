USE nyc_taxi_ldw
GO

--create CETAS table in parquet format 

CREATE OR ALTER PROCEDURE silver.usp_silver_trip_type
AS
BEGIN 

    IF OBJECT_ID('silver.trip_type') IS NOT NULL 
    DROP EXTERNAL TABLE silver.trip_type;

    CREATE EXTERNAL TABLE silver.trip_type
    WITH
    (
	    DATA_SOURCE=nyc_taxi_ext_data_src,
	    LOCATION='silver/trip_type',   --creates a separate folder silver in container
	    FILE_FORMAT=parquet_file_format
    )
    AS
    SELECT * FROM bronze.trip_type;

END;