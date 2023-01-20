USE nyc_taxi_discovery;


SELECT rate_code_id,rate_code
FROM OPENROWSET(
    BULK 'rate_code.json',
    DATA_SOURCE ='nyc_taxi_data_ext_raw',
    FORMAT = 'CSV',
    FIELDTERMINATOR='0x0b', 
    FIELDQUOTE='0x0b',       
    ROWTERMINATOR='0x0b'    -- USE vertical tab to overwrite the already present newline character in the file 
)
with (
    jsonDoc NVARCHAR(MAX)
) AS rate_code
CROSS APPLY OPENJSON(jsonDoc)
with (
    rate_code_id TINYINT,
    rate_code VARCHAR(20) 
);  


----- Process multi-line file 
-- Multi line json file same as standard json file


SELECT rate_code_id,rate_code
FROM OPENROWSET(
    BULK 'rate_code_multi_line.json',
    DATA_SOURCE ='nyc_taxi_data_ext_raw',
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
