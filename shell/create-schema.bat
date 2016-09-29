set PGBIN=C:\Program Files\PostgreSQL\9.3\bin\
set PGPORT=5432
set PGHOST=localhost
set PGUSER=postgres
set PGPASSWORD=postgres
set PGDATABASE=postgres
set PSQL="%PGBIN%psql"
set SHP2PGSQL="%PGBIN%shp2pgsql"


%PSQL% -c "DROP SCHEMA IF EXISTS zillow CASCADE;"
%PSQL% -c "CREATE SCHEMA zillow;"
