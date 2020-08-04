library(DBI)
library(dbplyr)
library(dplyr)
library(DT)
library(magrittr)
library(rhandsontable)
library(RSQLite)
library(shiny)
library(shinydashboard)
library(shinyFeedback)
library(shinyjs)
library(shinyWidgets)
library(stringr)
library(tychobratools)
library(uuid)

Sys.setenv(R_CONFIG_ACTIVE = "default")
#Sys.setenv(R_CONFIG_ACTIVE = "production")
app_config <- config::get()

conn <- NULL
tryCatch(conn <- db_connect(app_config$db), error = function(err) print(err))


local_conn <- dbConnect(SQLite(), "data/course_data.db")

course_codes_with_semester <- local_conn %>% 
  tbl("courses") %>% 
  collect()

all_courses <- course_codes_with_semester %>% 
  select(-semester) %>% 
  group_by(course_code) %>% 
  slice(1) %>% # Get most recent name
  arrange(course_code)

all_departments <- local_conn %>% 
  tbl("departments") %>% 
  collect() %>% 
  filter(code %in% unique(all_courses$department)) %>% 
  arrange(code)


majors_table <- readRDS("data/majors.RDS")
majors_list <- readRDS("data/majors_list.RDS")

course_codes_to_name <- function(codes) {
  tibble(course_code = codes) %>% 
    left_join(all_courses, by = "course_code") %>% 
    mutate(name = ifelse(is.na(name), "", name)) %>% 
    pull(name)
}
