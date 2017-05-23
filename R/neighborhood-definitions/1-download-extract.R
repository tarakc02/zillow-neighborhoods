## first step: download all the zillow neighborhood definitions
library(rvest)
library(dplyr)
library(purrr)
library(tidyr)

# links to the zip file are all listed here:
neighborhood_db_url <- "http://www.zillow.com/howto/api/neighborhood-boundaries.htm"

# import the page,
neighborhood_db_page <- read_html(neighborhood_db_url)

# and extract the urls for the files,
# easy to keep everything organized by keeping it all in one data frame
download_list <- neighborhood_db_page %>%
    html_nodes(".zsg-content-component a") %>%
    data_frame(
        area = html_text(.),
        url = unlist(html_attrs(.))
    ) %>%
    select(area, url) %>%
    #mutate(url = paste0("http://www.zillow.com", url)) %>%
    mutate(destfile = paste0("downloaded-data/", basename(url)))

# i'll use this directory to place all of the data
if (!dir.exists("downloaded-data")) dir.create("downloaded-data")

# download everything
# can check status afterwards by inspecting the "downloaded" column,
# which == 0 if there were no problems
download_list <- download_list %>%
    mutate(downloaded = map2_int(
        url,
        destfile,
        .f = download.file)
    )

# unzip all files (and place contents in same directory)
# again, the "files" column also serves as a record of what was extracted
download_list <- download_list %>%
    mutate(files = map(destfile, unzip, exdir = "downloaded-data"))

