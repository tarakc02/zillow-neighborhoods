set PGBIN=C:\Program Files\PostgreSQL\9.3\bin\
set PGPORT=5432
set PGHOST=localhost
set PGUSER=postgres
set PGPASSWORD=postgres
set PGDATABASE=postgres
set PSQL="%PGBIN%psql"
set SHP2PGSQL="%PGBIN%shp2pgsql"

cd downloaded-data
%SHP2PGSQL% -s 4269 -g the_geom -p ZillowNeighborhoods-UT zillow.neighborhoods | %PSQL% -h %PGHOST% -d %PGDATABASE% -U %PGUSER%

for %%f in (*.shp) do (
    %SHP2PGSQL% -s 4269 -g the_geom -a %%f zillow.neighborhoods | %PSQL% -h %PGHOST% -d %PGDATABASE% -U %PGUSER%
)

%PSQL% -c "CREATE INDEX zillow_neighborhood_the_geom_gist ON zillow.neighborhoods USING gist(the_geom);"
%PSQL% -c "CREATE INDEX zillow_neighborhood_regionid_idx ON zillow.neighborhoods (regionid);"
