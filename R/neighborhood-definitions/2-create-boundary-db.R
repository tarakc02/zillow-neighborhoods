## note: i found the correct srid based on the .prj files and this helpful
## site: http://prj2epsg.org/search

# create a schema called "zillow" in the postgres db
shell("shell\\create-schema.bat")

# populate it with all shapefiles  the downloaded-data directory
shell("shell\\populate-tables.bat")