library(dplyr)
library(RPostgres)

Sys.setenv("R_CONFIG_ACTIVE" = "default")
app_config <- config::get(file = "shiny_app/config.yml")
conn <- tychobratools::db_connect(app_config$db)

DBI::dbExecute(conn, "DROP TABLE IF EXISTS input_ids")

ids_table_query <- "CREATE TABLE input_ids (
  id                SERIAL PRIMARY KEY,
  time_created      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  passkey           TEXT,
  name              TEXT
);"

DBI::dbExecute(conn, ids_table_query)

semester_courses <- tibble(
  id = numeric(0),
  semester = character(0),
  code = character(0),
  name = character(0)
)

DBI::dbWriteTable(
  conn,
  "semester_courses",
  semester_courses,
  row.names = FALSE,
  overwrite = TRUE
)

majors <- tibble(
  id = numeric(0),
  code = character(0),
  name = character(0),
  major_name = character(0),
  major_id = character(0)
)

DBI::dbWriteTable(
  conn,
  "majors",
  majors,
  row.names = FALSE,
  overwrite = TRUE
)

DBI::dbDisconnect(conn)
