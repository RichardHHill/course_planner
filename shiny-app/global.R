library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinyjs)
library(dplyr)
library(DT)

options(scipen = 999)

majors_table <- readRDS("data/majors.RDS")

math_courses <- readRDS("data/math.RDS")

math_ab <- readRDS("data/math_ab.RDS")
econ_ab <- readRDS("data/econ_ab.RDS")

majors_list <- list(
  "math_ab" = math_ab,
  "econ_ab" = econ_ab
)
