IF (NOT EXISTS(SELECT * FROM sys.credentials WHERE name = 'cosmos-db-synapse-course'))
    CREATE CREDENTIAL [cosmos-db-synapse-course]
    WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = ' '
GO

SELECT TOP 100 *
FROM OPENROWSET(​PROVIDER = 'CosmosDB',
                CONNECTION = 'Account=cosmos-db-synapse-course;Database=nyctaxidb',
                OBJECT = 'Heartbeat',
                SERVER_CREDENTIAL = 'cosmos-db-synapse-course'
) AS [Heartbeat]
