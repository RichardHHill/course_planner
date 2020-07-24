library(dplyr)
library(RPostgres)

Sys.setenv("R_CONFIG_ACTIVE" = "default")
app_config <- config::get(file = "shiny_app/config.yml")
conn <- tychobratools::db_connect(app_config$db)

# DBI::dbExecute(conn, "DROP TABLE IF EXISTS input_ids")
# DBI::dbExecute(conn, "DROP TABLE IF EXISTS semester_courses")
# DBI::dbExecute(conn, "DROP TABLE IF EXISTS majors")

ids_table_query <- "CREATE TABLE input_ids (
  uid               VARCHAR(36) PRIMARY KEY,
  time_created      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  time_modified     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  passkey           TEXT,
  name              TEXT
);"

DBI::dbExecute(conn, ids_table_query)

semester_courses_query <- "CREATE TABLE semester_courses (
  uid               VARCHAR(36),
  semester          TEXT,
  code              TEXT,
  name              TEXT
);"

DBI::dbExecute(conn, semester_courses_query)

majors_query <- "CREATE TABLE majors (
  uid               VARCHAR(36),
  code              TEXT,
  name              TEXT,
  major_name        TEXT,
  major_id          TEXT
);"

DBI::dbExecute(conn, majors_query)

DBI::dbDisconnect(conn)
