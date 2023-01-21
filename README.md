# Synapse_NYC_Taxi
- Worked on Trip Data from New York City Taxi services
- Utilized green taxi data for 2020 (12 months), 2021(6 months) 
- 1] Serverless SQL Pool:
- Stored data in the raw container of data lake.
- Synapse studio used OPENROWSET function to query the file from data storage (data lake) without loading them into databases.
- Created external data sources, external tables, views, stored procedures using Serverless SQL Pool.
- Three schemas are created bronze, silver, gold & transformed the data from bronze to silver to gold layer using Serverless SQL Pool. 
- Most work is done in database named nyc_taxi_ldw.
- Created pipelines and trigger to run the pipeline at scheduled data and time.
- Pipelines are created using linked services. 
- 2] Spark Pook:
- Created Apache Spark Pool named 'coursepool'. 
- Pyspark notebook '1_spark_create_gold_trip_data_green_agg' is created in synapse studio. It shows integration between serverless sql pool and spark pool.
- 3] Cosmos DB:
- Created Azure Cosmos DB account with name 'cosmos-db-synapse-course'. Created database nyctaxidb in it and container named Heartbeat.
- A linked service named 'ls_cosmos_db_nyc_taxi_data' is created in synapse studio. 
- i]This linked service has sql script named '1_synapse_link_query_heartbeat' to connect synapse serverless sql pool to cosmos db.
- ii] This linked service has PySpark notebook named "1_synapse_link_query_heartbeat_sparkpool" that connect apache spark pool to cosmos db.
- 4]Dedicated SQL Pool:
- Created a dedicated SQL pool named: "nyc_taxi_dwh"
- Two methods to load data from table in datalake container to database in dedicated sql pool
- i]1_ctas_trip_data_green_agg uses Polybase method 
- ii]2_trip_data_green_agg_copy uses copy statement 

 
