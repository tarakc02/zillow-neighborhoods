config <- function(query) {
    # constants for local postgres database
    postgres_username <- Sys.getenv("POSTGRES_USERNAME")
    postgres_password <- Sys.getenv("POSTGRES_PW")
    postgres_host <- "localhost"
    postgres_port <- 5432
    geo_dbname <- "postgres"
    
    get(query, inherits = FALSE)
}

connect_geo_db <- function() {
    DBI::dbConnect(
        RPostgreSQL::PostgreSQL(), 
        user = config("postgres_username"), 
        password = config("postgres_password"),
        dbname = config("geo_dbname"),
        host = config("postgres_host"),
        port = config("postgres_port")
    )
}

disconnect_geo_db <- function(connection) {
    DBI::dbDisconnect(connection)
}

query_geo_db <- function(connection, query) {
    dplyr::tbl_df(DBI::dbGetQuery(connection, query))
}

read_query <- function(filename) {
    text_con <- file(filename, open = "rt")
    on.exit(close(text_con))
    paste(readLines(text_con), collapse = "\n")
}