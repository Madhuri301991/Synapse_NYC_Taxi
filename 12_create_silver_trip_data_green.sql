USE nyc_taxi_ldw;

--create CETAS table in parquet format 

IF OBJECT_ID('silver.trip_data_green') IS NOT NULL 
DROP EXTERNAL TABLE silver.trip_data_green
GO
-- drop external table manually from silver folder in container because external table location is not deleted 

---------------------------------------------------------------------------------------------------

CREATE EXTERNAL TABLE silver.trip_data_green
WITH
(
	DATA_SOURCE=nyc_taxi_ext_data_src,
	LOCATION='silver/trip_data_green',  
	FILE_FORMAT=parquet_file_format
)
AS
SELECT * FROM bronze.trip_data_green_csv;

--- CETAS write all partition in one folder, so no  meaning of partition -- limitation of CETAS, cannot create partition

---------------------------------------------------------------------------

SELECT Top(100) * FROM silver.trip_data_green;

-----------------------------------------------------------------------------------------------------

CREATE EXTERNAL TABLE silver.trip_data_green_20202_01
WITH
(
	DATA_SOURCE=nyc_taxi_ext_data_src,
	LOCATION='silver/trip_data_green/year=2020/month=01',  
	FILE_FORMAT=parquet_file_format
)
AS
SELECT * FROM bronze.vw_trip_data_green_csv
WHERE year='2020'
AND month='01';  --view because partition doesnt exist on external table

select top(100) * from silver.trip_data_green_20202_01;
