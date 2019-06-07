library(openxlsx)
library(dplyr)

file_path <- "data/provided/Department Courses.xlsx"

majors_table <- tibble(
  "major" = c(
    "math_ab",
    "econ_ab"
  ),
  "display" = c(
    "Math AB",
    "Econ AB"
  )
)

saveRDS(majors_table, "shiny-app/data/majors.RDS")

#math department courses
math_table <- read.xlsx(
  file_path,
  sheet = 1,
  rows = 2:34,
  cols = 1:2
)

saveRDS(math_table, "shiny-app/data/math.RDS")

econ_table <- read.xlsx(
  file_path,
  sheet = 1,
  rows = 2:41,
  cols = 4:5
)

saveRDS(econ_table, "shiny-app/data/econ.RDS")

math_ab <- read.xlsx(
  file_path,
  sheet = 2,
  rows = 3:21,
  cols = 1:4,
  colNames = FALSE
)

saveRDS(math_ab, "shiny-app/data/math_ab.RDS")

econ_ab <- read.xlsx(
  file_path,
  sheet = 2,
  rows = 27:56,
  cols = 1:7,
  colNames = FALSE
)

saveRDS(econ_ab, "shiny-app/data/econ_ab.RDS")