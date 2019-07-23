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


Sys.setenv(R_CONFIG_ACTIVE = "default")
#Sys.setenv(R_CONFIG_ACTIVE = "production")
app_config <- config::get()
conn <- tychobratools::db_connect(app_config$db)


options(scipen = 999)


majors_table <- readRDS("data/majors.RDS")
majors_list <- readRDS("data/majors_list.RDS")
department_list <- readRDS("data/department_list.RDS")

helpers <- source("helpers/course_helpers.R", local = TRUE)$value

source("modules/semester_module.R")
source("modules/input_major_module.R")
source("modules/major_table_module.R")
