USE nyc_taxi_ldw
GO

--create CETAS table in parquet format 

CREATE OR ALTER PROCEDURE silver.usp_silver_taxi_zone
AS
BEGIN 

    IF OBJECT_ID('silver.taxi_zone') IS NOT NULL 
    DROP EXTERNAL TABLE silver.taxi_zone;

    CREATE EXTERNAL TABLE silver.taxi_zone
    WITH
    (
	    DATA_SOURCE=nyc_taxi_ext_data_src,
	    LOCATION='silver/taxi_zone',   --creates a separate folder silver in container
	    FILE_FORMAT=parquet_file_format
    )
    AS
    SELECT * FROM bronze.taxi_zone;

END;
------------------------------------------------------------------------------
