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
cads_addresses <- getcdw::get_cdw("sql/addresses-from-cads.sql")
postgres <- connect_geo_db()
query_geo_db(postgres, "delete from cads.geocodes")
DBI::dbWriteTable(
    postgres, 
    name = c("cads", "geocodes"), 
    value = cads_addresses, 
    append = TRUE,
    row.names=FALSE
)
cads_neighborhoods <- query_geo_db(
    postgres,
    query = read_query("sql/cads-neighborhoods.sql")
)
disconnect_geo_db(postgres)

sold_price_sf <- readr::read_csv("downloaded-data/metrics/Neighborhood_MedianSoldPricePerSqft_AllHomes.csv")
library(stringr)
sold_price_sf %<>% 
    gather(month, price, starts_with("1"), starts_with("2")) %>%
    filter(str_detect(month, "(^2017)|(^2016)"), !is.na(price)) %>%
    group_by(RegionID) %>% 
    filter(month == max(month)) %>% ungroup

cads_neighborhoods %>%
    mutate(regionid = as.integer(regionid)) %>%
    inner_join(sold_price_sf, by = c("regionid" = "RegionID")) %>%
    select(entity_id, price_sq_ft = price) %>%
    write.csv("R:/Prospect Development/Prospect Analysis/external_datasets/home_price_sq_ft.csv", row.names = FALSE)