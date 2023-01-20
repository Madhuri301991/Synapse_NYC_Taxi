USE nyc_taxi_ldw
GO

--create CETAS table in parquet format 

CREATE OR ALTER PROCEDURE silver.usp_silver_rate_code
AS
BEGIN 

    IF OBJECT_ID('silver.rate_code') IS NOT NULL 
    DROP EXTERNAL TABLE silver.rate_code;

    CREATE EXTERNAL TABLE silver.rate_code
    WITH
    (
	    DATA_SOURCE=nyc_taxi_ext_data_src,
	    LOCATION='silver/rate_code',   --creates a separate folder silver in container
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

END;