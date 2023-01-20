USE nyc_taxi_ldw;



IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name='nyc_taxi_ext_data_src')
    CREATE EXTERNAL DATA SOURCE nyc_taxi_ext_data_src
    WITH 
    (   
        LOCATION='https://coursesynapsedatalake.dfs.core.windows.net/nyc-taxi-data'
    );