library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinyjs)
library(dplyr)
library(DT)
library(shinycssloaders)
library(tychobratools)
library(DBI)
library(dbplyr)
library(rhandsontable)
library(V8)
library(magrittr)
library(stringr)
library(RSQLite)

Sys.setenv(R_CONFIG_ACTIVE = "default")
#Sys.setenv(R_CONFIG_ACTIVE = "production")
app_config <- config::get()
conn <- db_connect(app_config$db)

local_conn <- dbConnect(SQLite(), "data/course_data.db")

course_codes_with_semester <- local_conn %>% 
  tbl("courses") %>% 
  collect()

course_codes <- course_codes_with_semester %>% 
  select(-semester) %>% 
  distinct() %>% 
  arrange(course_code)

all_departments <- local_conn %>% 
  tbl("departments") %>% 
  collect() %>% 
  filter(code %in% unique(course_codes$department))


majors_table <- readRDS("data/majors.RDS")
majors_list <- readRDS("data/majors_list.RDS")
department_list <- readRDS("data/department_list.RDS")

source("modules/semester_module.R")

course_code_to_name <- function(code) {
  department <- word(code)
  
  if (department %in% names(department_list)) {
    department_table <- department_list[[department]]
    
    index <- match(code, department_table$course_code)
    
    if (is.na(index)) out <- "" else out <- department_table$course_name[[index]]
  } else {
    out <- ""
  }
  
  out
}
