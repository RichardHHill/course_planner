library(dplyr)
library(RPostgres)

Sys.setenv("R_CONFIG_ACTIVE" = "default")
app_config <- config::get(file = "shiny_app/config.yml")
conn <- tychobratools::db_connect(app_config$db)

DBI::dbExecute(conn, "DROP TABLE IF EXISTS semester_names")
DBI::dbExecute(conn, "DROP TABLE IF EXISTS semester_courses")
DBI::dbExecute(conn, "DROP TABLE IF EXISTS majors")
DBI::dbExecute(conn, "DROP TABLE IF EXISTS input_ids")

ids_table_query <- "CREATE TABLE input_ids (
  uid               VARCHAR(36) PRIMARY KEY,
  time_created      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  time_modified     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  passkey           TEXT,
  name              TEXT
);"

DBI::dbExecute(conn, ids_table_query)

semester_names_query <- "CREATE TABLE semester_names (
  semester_uid      VARCHAR(36) PRIMARY KEY,
  schedule_uid      VARCHAR(36) REFERENCES input_ids (uid) ON DELETE CASCADE,
  semester_name     TEXT
);"

DBI::dbExecute(conn, semester_names_query)

semester_courses_query <- "CREATE TABLE semester_courses (
  schedule_uid      VARCHAR(36) REFERENCES input_ids (uid) ON DELETE CASCADE,
  semester_uid      VARCHAR(36) REFERENCES semester_names (semester_uid) ON DELETE CASCADE,
  semester          TEXT,
  code              TEXT,
  name              TEXT
);"

DBI::dbExecute(conn, semester_courses_query)

majors_query <- "CREATE TABLE majors (
  schedule_uid      VARCHAR(36) REFERENCES input_ids (uid) ON DELETE CASCADE,
  code              TEXT,
  name              TEXT,
  major_name        TEXT,
  major_id          TEXT
);"

DBI::dbExecute(conn, majors_query)

DBI::dbDisconnect(conn)
