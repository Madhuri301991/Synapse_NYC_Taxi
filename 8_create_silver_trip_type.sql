USE nyc_taxi_ldw;

--create CETAS table in parquet format 


IF OBJECT_ID('silver.trip_type') IS NOT NULL 
DROP EXTERNAL TABLE silver.trip_type
GO
-- drop external table manually from silver folder in container because external table location is not deleted 

---------------------------------------------------------------------------------------------------

CREATE EXTERNAL TABLE silver.trip_type
WITH
(
	DATA_SOURCE=nyc_taxi_ext_data_src,
	LOCATION='silver/trip_type',  
	FILE_FORMAT=parquet_file_format
)
AS
SELECT * FROM bronze.trip_type;

------------------------------------------------------------------------------

SELECT * FROM silver.trip_type;