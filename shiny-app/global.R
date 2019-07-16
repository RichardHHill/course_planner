library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinyjs)
library(dplyr)
library(DT)


#Sys.setenv(R_CONFIG_ACTIVE = "default")
#Sys.setenv(R_CONFIG_ACTIVE = "production")
#app_config <- config::get()
#conn <- tychobratools::db_connect(app_config)


options(scipen = 999)


majors_table <- readRDS("data/majors.RDS")

math_courses <- readRDS("data/math.RDS")
econ_courses <- readRDS("data/econ.RDS")
apma_courses <- readRDS("data/apma.RDS")
phys_courses <- readRDS("data/phys.RDS")
csci_courses <- readRDS("data/csci.RDS")
fren_courses <- readRDS("data/fren.RDS")
hisp_courses <- readRDS("data/hisp.RDS")

math_ab <- readRDS("data/math_ab.RDS")
econ_ab <- readRDS("data/econ_ab.RDS")
apma_ab <- readRDS("data/apma_ab.RDS")
mathcs_scb <- readRDS("data/mathcs_scb.RDS")

#convert string to data frame
majors_list <- list(
  "math_ab" = math_ab,
  "econ_ab" = econ_ab,
  "apma_ab" = apma_ab,
  "mathcs_scb" = mathcs_scb
)

department_list <- list(
  "MATH" = math_courses,
  "ECON" = econ_courses,
  "APMA" = apma_courses,
  "PHYS" = phys_courses,
  "CSCI" = csci_courses,
  "FREN" = fren_courses,
  "HISP" = hisp_courses
)

helpers <- source("helpers/course_helpers.R", local = TRUE)$value

source("modules/semester_module.R")
source("modules/input_major_module.R")
source("modules/major_table_module.R")
