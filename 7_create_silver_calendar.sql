USE nyc_taxi_ldw;

--create CETAS table in parquet format 


IF OBJECT_ID('silver.calendar') IS NOT NULL 
DROP EXTERNAL TABLE silver.calendar
GO
-- drop external table manually from silver folder in container because external table location is not deleted 

---------------------------------------------------------------------------------------------------

CREATE EXTERNAL TABLE silver.calendar
WITH
(
	DATA_SOURCE=nyc_taxi_ext_data_src,
	LOCATION='silver/calendar',  
	FILE_FORMAT=parquet_file_format
)
AS
SELECT * FROM bronze.calendar;

------------------------------------------------------------------------------

SELECT * FROM silver.calendar;
