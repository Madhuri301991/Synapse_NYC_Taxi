USE nyc_taxi_ldw;

--create CETAS table in parquet format 


IF OBJECT_ID('silver.taxi_zone') IS NOT NULL 
DROP EXTERNAL TABLE silver.taxi_zone
GO
-- drop taxi_zone table manually from silver folder in container because external table location is not deleted 

---------------------------------------------------------------------------------------------------

CREATE EXTERNAL TABLE silver.taxi_zone
WITH
(
	DATA_SOURCE=nyc_taxi_ext_data_src,
	LOCATION='silver/taxi_zone',   --creates a separate folder silver in container
	FILE_FORMAT=parquet_file_format
)
AS
SELECT * FROM bronze.taxi_zone;

------------------------------------------------------------------------------

SELECT * FROM silver.taxi_zone;