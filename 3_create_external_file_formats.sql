USE nyc_taxi_ldw;


-----------------------------------------------------------------------------------------------------------------------

-- Create file format csv_file_format for parser version 2.0


IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name='csv_file_format')
	CREATE EXTERNAL FILE FORMAT csv_file_format
	WITH(
   		FORMAT_TYPE=DELIMITEDTEXT,
    	FORMAT_OPTIONS(
		FIELD_TERMINATOR=',',
		STRING_DELIMITER='"',
		FIRST_ROW=2,
		USE_TYPE_DEFAULT=FALSE,
		ENCODING='UTF8',
		PARSER_VERSION='2.0'
    	)
	);


-----------------------------------------------------------------------------------------------------------


-- Create file format csv_file_format for parser version 1.0


IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name='csv_file_format_pv1')   -- if doesnt exist then create file format
	CREATE EXTERNAL FILE FORMAT csv_file_format_pv1  --file format for parser_version=1
	WITH(
    	FORMAT_TYPE=DELIMITEDTEXT,
    	FORMAT_OPTIONS(
		FIELD_TERMINATOR=',',
		STRING_DELIMITER='"',
		FIRST_ROW=2,
		USE_TYPE_DEFAULT=FALSE,
		ENCODING='UTF8',
		PARSER_VERSION='1.0'
    	)
	);

---------------------------------------------------------------------------------------------------------------------------------------------------------

-- Create file format tsv_file_format for parser version 2.0

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name='tsv_file_format')  
	CREATE EXTERNAL FILE FORMAT tsv_file_format
	WITH(
    	FORMAT_TYPE=DELIMITEDTEXT,
    	FORMAT_OPTIONS(
		FIELD_TERMINATOR='\t',
		STRING_DELIMITER='"',
		FIRST_ROW=2,
		USE_TYPE_DEFAULT=FALSE,
		ENCODING='UTF8',
		PARSER_VERSION='2.0'
    	)
	);
---------------------------------------------------------------------------------------------------------------------------------------

-- Create file format tsv_file_format for parser version 1.0

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name='tsv_file_format_pv1')  
	CREATE EXTERNAL FILE FORMAT tsv_file_format_pv1
	WITH(
    	FORMAT_TYPE=DELIMITEDTEXT,
    	FORMAT_OPTIONS(
		FIELD_TERMINATOR='\t',
		STRING_DELIMITER='"',
		FIRST_ROW=2,
		USE_TYPE_DEFAULT=FALSE,
		ENCODING='UTF8',
		PARSER_VERSION='1.0'
    	)
	);

-- Create external file format for parquet file format 

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name='parquet_file_format')
   CREATE EXTERNAL FILE FORMAT parquet_file_format
   WITH (
	FORMAT_TYPE=parquet,
	DATA_COMPRESSION='org.apache.hadoop.io.compress.SnappyCodec'     --parquet file is compressed using snappy compression
        );

-- Create external file format for delta file format 

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name='delta_file_format')
   CREATE EXTERNAL FILE FORMAT delta_file_format
   WITH (
	FORMAT_TYPE=delta,
	DATA_COMPRESSION='org.apache.hadoop.io.compress.SnappyCodec' 
        );
