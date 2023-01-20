USE nyc_taxi_ldw;

--create CETAS table in parquet format from JSON format


IF OBJECT_ID('silver.payment_type') IS NOT NULL 
DROP EXTERNAL TABLE silver.payment_type
GO
-- drop external table manually from silver folder in container because external table location is not deleted 

---------------------------------------------------------------------------------------------------

CREATE EXTERNAL TABLE silver.payment_type
WITH
(
	DATA_SOURCE=nyc_taxi_ext_data_src,
	LOCATION='silver/payment_type',  
	FILE_FORMAT=parquet_file_format
)
AS
SELECT payment_type,description
FROM OPENROWSET(
    BULK 'raw/payment_type.json',
    DATA_SOURCE ='nyc_taxi_ext_data_src',
    FORMAT = 'CSV',
    FIELDTERMINATOR='0x0b', 
    FIELDQUOTE='0x0b'       
)
with (
    jsonDoc NVARCHAR(MAX)
) AS payment_type
CROSS APPLY OPENJSON(jsonDoc)
with (
    payment_type SMALLINT,
    description VARCHAR(20) '$.payment_type_desc'
); 
-- use either rate_code view or openrowset because json file dont have external table 
------------------------------------------------------------------------------

SELECT * FROM silver.payment_type;