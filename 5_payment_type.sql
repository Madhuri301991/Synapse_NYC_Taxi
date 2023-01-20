USE nyc_taxi_discovery;

-- read all JSON document into one field (as one column)
-- 0x0b for vertical tab 
-- 0x0a for newline

SELECT 
*
FROM OPENROWSET(
    BULK 'payment_type.json',
    DATA_SOURCE ='nyc_taxi_data_ext_raw',
    FORMAT = 'CSV',
    PARSER_VERSION='1.0',
    FIELDTERMINATOR='0x0b', 
    FIELDQUOTE='0x0b',
    ROWTERMINATOR='0x0a'        
)
with (
    jsonDoc NVARCHAR(MAX)
) AS payment_type;

--USING JSON_VALUE-- Pull out properties into different columns 

SELECT JSON_VALUE(jsonDoc,'$.payment_type') payment_type,
       JSON_VALUE(jsonDoc,'$.payment_type_desc') payment_type_desc
FROM OPENROWSET(
    BULK 'payment_type.json',
    DATA_SOURCE ='nyc_taxi_data_ext_raw',
    FORMAT = 'CSV',
    PARSER_VERSION='1.0',
    FIELDTERMINATOR='0x0b', 
    FIELDQUOTE='0x0b',
    ROWTERMINATOR='0x0a'        
)
with (
    jsonDoc NVARCHAR(MAX)
) AS payment_type;


-- SPECIFY DATATYPE OF COLUMNS 

SELECT CAST(JSON_VALUE(jsonDoc,'$.payment_type') AS SMALLINT) payment_type,
       CAST(JSON_VALUE(jsonDoc,'$.payment_type_desc') AS VARCHAR(15)) payment_type_desc
FROM OPENROWSET(
    BULK 'payment_type.json',
    DATA_SOURCE ='nyc_taxi_data_ext_raw',
    FORMAT = 'CSV',
    PARSER_VERSION='1.0',
    FIELDTERMINATOR='0x0b', 
    FIELDQUOTE='0x0b',
    ROWTERMINATOR='0x0a'        
)
with (
    jsonDoc NVARCHAR(MAX)
) AS payment_type;

-- CHECK THE DATATYPE OF THE COLUMN 

EXEC sp_describe_first_result_set N'
SELECT CAST(JSON_VALUE(jsonDoc,''$.payment_type'') AS SMALLINT) payment_type,
       CAST(JSON_VALUE(jsonDoc,''$.payment_type_desc'') AS VARCHAR(15)) payment_type_desc
FROM OPENROWSET(
    BULK ''payment_type.json'',
    DATA_SOURCE =''nyc_taxi_data_ext_raw'',
    FORMAT = ''CSV'',
    PARSER_VERSION=''1.0'',
    FIELDTERMINATOR=''0x0b'', 
    FIELDQUOTE=''0x0b'',
    ROWTERMINATOR=''0x0a''        
)
with (
    jsonDoc NVARCHAR(MAX)
) AS payment_type';


--- USING OPENJSON --  read all JSON document into one field (as one column)
SELECT *
FROM OPENROWSET(
    BULK 'payment_type.json',
    DATA_SOURCE ='nyc_taxi_data_ext_raw',
    FORMAT = 'CSV',
    FIELDTERMINATOR='0x0b', 
    FIELDQUOTE='0x0b'       
)
with (
    jsonDoc NVARCHAR(MAX)
) AS payment_type
CROSS APPLY OPENJSON(jsonDoc);   
-- cross apply = joins openjson with the results of from clause, 
-- CROSS APPLY = equivalent to inner join without any join conditions
-- Output from openrowset is held in jsonDoc, jsonDoc is then pushed into OPENJSON function 


-- Using OPENJSON ---- Pull out properties into different columns 

SELECT payment_type,payment_type_desc
FROM OPENROWSET(
    BULK 'payment_type.json',
    DATA_SOURCE ='nyc_taxi_data_ext_raw',
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
    payment_type_desc VARCHAR(20)
);  


-- Rename the column names

SELECT payment_type,description
FROM OPENROWSET(
    BULK 'payment_type.json',
    DATA_SOURCE ='nyc_taxi_data_ext_raw',
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


-----------------------------------------------------------------
-- Reading data from JSON with arrays 
----------------------------------------------------------------

SELECT *
FROM OPENROWSET(
    BULK 'payment_type_array.json',
    DATA_SOURCE ='nyc_taxi_data_ext_raw',
    FORMAT = 'CSV',
    PARSER_VERSION='1.0',
    FIELDTERMINATOR='0x0b', 
    FIELDQUOTE='0x0b',
    ROWTERMINATOR='0x0a'        
)
with (
    jsonDoc NVARCHAR(MAX)
) AS payment_type;


-- exploding array in two different columns 


SELECT CAST(JSON_VALUE(jsonDoc,'$.payment_type') AS SMALLINT) payment_type,
       CAST(JSON_VALUE(jsonDoc,'$.payment_type_desc[0].value') AS VARCHAR(15)) payment_type_desc_0,
       CAST(JSON_VALUE(jsonDoc,'$.payment_type_desc[1].value') AS VARCHAR(15)) payment_type_desc_1
FROM OPENROWSET(
    BULK 'payment_type_array.json',
    DATA_SOURCE ='nyc_taxi_data_ext_raw',
    FORMAT = 'CSV',
    PARSER_VERSION='1.0',
    FIELDTERMINATOR='0x0b', 
    FIELDQUOTE='0x0b',
    ROWTERMINATOR='0x0a'        
)
with (
    jsonDoc NVARCHAR(MAX)
) AS payment_type;


-- Use openjson to explode the array 
SELECT *
FROM OPENROWSET(
    BULK 'payment_type_array.json',
    DATA_SOURCE ='nyc_taxi_data_ext_raw',
    FORMAT = 'CSV',
    PARSER_VERSION='1.0',
    FIELDTERMINATOR='0x0b', 
    FIELDQUOTE='0x0b',
    ROWTERMINATOR='0x0a'        
)
with (
    jsonDoc NVARCHAR(MAX)
) AS payment_type
CROSS APPLY OPENJSON(jsonDoc)
with (
    payment_type SMALLINT,
    payment_type_desc NVARCHAR(MAX) AS JSON
)
CROSS APPLY OPENJSON(payment_type_desc)    --explodes the payment_type_desc as per no of array elements into different records
with (
    sub_type SMALLINT,
    value VARCHAR(20)
);


-- Use openjson to explore the array and renaming the column, retriving only the required column

SELECT payment_type,payment_type_desc_value
FROM OPENROWSET(
    BULK 'payment_type_array.json',
    DATA_SOURCE ='nyc_taxi_data_ext_raw',
    FORMAT = 'CSV',
    PARSER_VERSION='1.0',
    FIELDTERMINATOR='0x0b', 
    FIELDQUOTE='0x0b',
    ROWTERMINATOR='0x0a'        
)
with (
    jsonDoc NVARCHAR(MAX)
) AS payment_type
CROSS APPLY OPENJSON(jsonDoc)
with (
    payment_type SMALLINT,
    payment_type_desc NVARCHAR(MAX) AS JSON
)
CROSS APPLY OPENJSON(payment_type_desc)    --explodes the payment_type_desc as per array elements
with (
    sub_type SMALLINT,
    payment_type_desc_value VARCHAR(20) '$.value'
);

