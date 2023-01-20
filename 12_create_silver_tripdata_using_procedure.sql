USE nyc_taxi_ldw
GO

-- First delete the silver.trip_data_green from silver folder of nyc-taxi-data


EXEC silver.usp_silver_trip_data_green '2020','01'
-- In the silver folder of nyc-taxi-data container, folder year=2020 is created inside trip_data_green folder


EXEC silver.usp_silver_trip_data_green '2020','02'

EXEC silver.usp_silver_trip_data_green '2020','03'
EXEC silver.usp_silver_trip_data_green '2020','04'
EXEC silver.usp_silver_trip_data_green '2020','05'
EXEC silver.usp_silver_trip_data_green '2020','06'
EXEC silver.usp_silver_trip_data_green '2020','07'
EXEC silver.usp_silver_trip_data_green '2020','08'
EXEC silver.usp_silver_trip_data_green '2020','09'
EXEC silver.usp_silver_trip_data_green '2020','10'
EXEC silver.usp_silver_trip_data_green '2020','11'
EXEC silver.usp_silver_trip_data_green '2020','12'
EXEC silver.usp_silver_trip_data_green '2021','01'
EXEC silver.usp_silver_trip_data_green '2021','02'
EXEC silver.usp_silver_trip_data_green '2021','03'
EXEC silver.usp_silver_trip_data_green '2021','04'
EXEC silver.usp_silver_trip_data_green '2021','05'
EXEC silver.usp_silver_trip_data_green '2021','06'

