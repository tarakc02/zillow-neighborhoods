source("R/metrics-dl/config.R")

# download the metrics files
# this is one file with all metrics by neighborhood
download.file("http://files.zillowstatic.com/research/public/Neighborhood.zip",
              destfile = "downloaded-data/metrics.zip")

if (!dir.exists("downloaded-data/metrics")) 
    dir.create("downloaded-data/metrics", recursive = TRUE)

unzip("downloaded-data/metrics.zip", 
      exdir = "downloaded-data/metrics", junkpaths = TRUE)

# quickie to get "neighborhood" of all home addresses in CADS
postgres <- connect_geo_db()
cads_neighborhoods <- query_geo_db(
    postgres,
    query = read_query("sql/cads-neighborhoods.sql")
)
disconnect_geo_db(postgres)

