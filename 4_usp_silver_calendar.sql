USE nyc_taxi_ldw
GO

--create CETAS table in parquet format 

CREATE OR ALTER PROCEDURE silver.usp_silver_calendar
AS
BEGIN 

    IF OBJECT_ID('silver.calendar') IS NOT NULL 
    DROP EXTERNAL TABLE silver.calendar;

    CREATE EXTERNAL TABLE silver.calendar
    WITH
    (
	    DATA_SOURCE=nyc_taxi_ext_data_src,
	    LOCATION='silver/calendar',   --creates a separate folder silver in container
	    FILE_FORMAT=parquet_file_format
    )
    AS
    SELECT * FROM bronze.calendar;

END;