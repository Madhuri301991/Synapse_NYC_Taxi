-- This is auto-generated code
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://coursesynapsedatalake.dfs.core.windows.net/nyc-taxi-data/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0'
    ) AS [result]


--- HEADER_ROW set to TRUE, ROW and FIELDTERMINATOR set
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@coursesynapsedatalake.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE,
        FIELDTERMINATOR=',',
        ROWTERMINATOR='\n'
    ) AS [result]


--- Examine the data types for the columns 
EXEC sp_describe_first_result_set N'SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK ''abfss://nyc-taxi-data@coursesynapsedatalake.dfs.core.windows.net/raw/taxi_zone.csv'',
        FORMAT = ''CSV'',
        PARSER_VERSION = ''2.0'',
        HEADER_ROW=TRUE
    ) AS [result]'



---Maximum length of each column


SELECT
    MAX(LEN(LocationID)) AS len_LocationId,
    MAX(LEN(Borough)) AS len_Borough,
    MAX(LEN(Zone)) AS len_Zone,
    MAX(LEN(service_zone)) AS len_service_zone
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@coursesynapsedatalake.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE,
        FIELDTERMINATOR=',',
        ROWTERMINATOR='\n'
    ) AS [result]


--- Use with clause to provide explicit data types
SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@coursesynapsedatalake.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE,
        FIELDTERMINATOR=',',
        ROWTERMINATOR='\n'
    ) 
    WITH(
        LocationID SMALLINT, 
        Borough VARCHAR(15),
        Zone VARCHAR(50),
        service_zone VARCHAR(15)
    ) AS [result]

--- Examine the data types for the columns 

EXEC sp_describe_first_result_set N'SELECT
        *
FROM
    OPENROWSET(
        BULK ''abfss://nyc-taxi-data@coursesynapsedatalake.dfs.core.windows.net/raw/taxi_zone.csv'',
        FORMAT = ''CSV'',
        PARSER_VERSION = ''2.0'',
        HEADER_ROW=TRUE
    ) 
    WITH(
        LocationID SMALLINT, 
        Borough VARCHAR(15),
        Zone VARCHAR(50),
        service_zone VARCHAR(15)
    ) AS [result]'



select name,collation_name FROM sys.databases;




-- SPECIFY UTF-8 collation for VARCHAR column using method1
SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@coursesynapsedatalake.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE,
        FIELDTERMINATOR=',',
        ROWTERMINATOR='\n'
    ) 
    WITH(
        LocationID SMALLINT, 
        Borough VARCHAR(15) COLLATE Latin1_General_100_CI_AI_SC_UTF8,
        Zone VARCHAR(50) COLLATE Latin1_General_100_CI_AI_SC_UTF8,
        service_zone VARCHAR(15) COLLATE Latin1_General_100_CI_AI_SC_UTF8
    ) AS [result]

--- Create a new database for project
CREATE DATABASE nyc_taxi_discovery;

USE nyc_taxi_discovery;

-- specify collation using method 2 by setting collation at database level

ALTER DATABASE nyc_taxi_discovery COLLATE Latin1_General_100_CI_AI_SC_UTF8;



SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@coursesynapsedatalake.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE
    ) 
    WITH(
        LocationID SMALLINT, 
        Borough VARCHAR(15),
        Zone VARCHAR(50),
        service_zone VARCHAR(15)
    ) AS [result]


--- Select only subset of columns 


SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@coursesynapsedatalake.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW=TRUE
    ) 
    WITH(
        Borough VARCHAR(15),
        Zone VARCHAR(50)
    ) AS [result]


-- Read data from a file without header 

SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@coursesynapsedatalake.dfs.core.windows.net/raw/taxi_zone_without_header.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0'
    ) 
    WITH(
        LocationID SMALLINT, 
        Borough VARCHAR(15),
        Zone VARCHAR(50),
        service_zone VARCHAR(15)
    )
AS [result]


--- Select only subset of columns from file without header 


SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@coursesynapsedatalake.dfs.core.windows.net/raw/taxi_zone_without_header.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0'
    ) 
    WITH(
         Zone VARCHAR(50) 3,
        Borough VARCHAR(15) 2
    )
AS [result]

----- Fix column names - change the column names

SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@coursesynapsedatalake.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIRSTROW=2   -- start from second record 
    ) 
    WITH(
        location_id SMALLINT 1, 
        borough VARCHAR(15) 2,
        zone VARCHAR(50) 3,
        service_zone VARCHAR(15) 4
    ) AS [result]

---- Change parser_version=1 so error messages can be properly displayed


SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@coursesynapsedatalake.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '1.0',
        FIRSTROW=2   -- start from second record 
    ) 
    WITH(
        location_id SMALLINT 1, 
        borough VARCHAR(15) 2,
        zone VARCHAR(50) 3,
        service_zone VARCHAR(15) 4
    ) AS [result]

-- CREATE EXTERNAL DATA SOURCE 

CREATE EXTERNAL DATA SOURCE nyc_taxi_data_ext
WITH(
    LOCATION='abfss://nyc-taxi-data@coursesynapsedatalake.dfs.core.windows.net/'
)


CREATE EXTERNAL DATA SOURCE nyc_taxi_data_ext_raw
WITH(
    LOCATION='abfss://nyc-taxi-data@coursesynapsedatalake.dfs.core.windows.net/raw'
)



--- Use external data source 


SELECT
    *
FROM
    OPENROWSET(
        BULK 'taxi_zone.csv',
        DATA_SOURCE='nyc_taxi_data_ext_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '1.0',
        FIRSTROW=2   -- start from second record 
    ) 
    WITH(
        location_id SMALLINT 1, 
        borough VARCHAR(15) 2,
        zone VARCHAR(50) 3,
        service_zone VARCHAR(15) 4
    ) AS [result]


--- DROP External data source 

DROP EXTERNAL DATA SOURCE nyc_taxi_data_ext;

--- Find out external data source points to which data source 

SELECT name,location FROM sys.external_data_sources;