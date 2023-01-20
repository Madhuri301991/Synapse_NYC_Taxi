USE nyc_taxi_ldw;

--create CETAS table in parquet format from JSON format


IF OBJECT_ID('silver.rate_code') IS NOT NULL 
DROP EXTERNAL TABLE silver.rate_code
GO
-- drop external table manually from silver folder in container because external table location is not deleted 

---------------------------------------------------------------------------------------------------

CREATE EXTERNAL TABLE silver.rate_code
WITH
(
	DATA_SOURCE=nyc_taxi_ext_data_src,
	LOCATION='silver/rate_code',  
	FILE_FORMAT=parquet_file_format
)
AS
SELECT rate_code_id,rate_code
FROM OPENROWSET(
    BULK 'raw/rate_code.json',
    DATA_SOURCE ='nyc_taxi_ext_data_src',
    FORMAT = 'CSV',
    FIELDTERMINATOR='0x0b', 
    FIELDQUOTE='0x0b',       
    ROWTERMINATOR='0x0b'   
)
with (
    jsonDoc NVARCHAR(MAX)
) AS rate_code
CROSS APPLY OPENJSON(jsonDoc)
with (
    rate_code_id TINYINT,
    rate_code VARCHAR(20) 
);  

-- use either rate_code view or openrowset to retrieve data, because json file dont have external table 
------------------------------------------------------------------------------

SELECT * FROM silver.rate_code;