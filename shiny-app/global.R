library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinyjs)
library(dplyr)
library(DT)

options(scipen = 999)

majors_table <- readRDS("data/majors.RDS")

math_courses <- readRDS("data/math.RDS")
econ_courses <- readRDS("data/econ.RDS")

math_ab <- readRDS("data/math_ab.RDS")
econ_ab <- readRDS("data/econ_ab.RDS")

#convert string to data frame
majors_list <- list(
  "math_ab" = math_ab,
  "econ_ab" = econ_ab
)

department_list <- list(
  "MATH" = math_courses,
  "ECON" = econ_courses
)

course_code_to_name <- function(course_code) {
 department <- substr(course_code, 1, 4)
 department_table <- department_list[[department]]
 index <- match(course_code, department_table$course_code)
 course_name <- department_table$course_name[[index]]
}
