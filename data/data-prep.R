library(openxlsx)
library(dplyr)

file_path <- "data/provided/Department Courses.xlsx"

majors_table <- tibble(
  "major" = c(
    "math_ab",
    "econ_ab",
    "apma_ab",
    "mathcs_scb"
  ),
  "display" = c(
    "Math AB",
    "Econ AB",
    "Apma AB",
    "Math-CS ScB"
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

apma_table <- read.xlsx(
  file_path,
  sheet = 1,
  rows = 2:23,
  cols = 7:8
)

saveRDS(apma_table, "shiny-app/data/apma.RDS")

phys_table <- read.xlsx(
  file_path,
  sheet = 1,
  rows = 2:28,
  cols = 10:11
)

saveRDS(phys_table, "shiny-app/data/phys.RDS")

csci_table <- read.xlsx(
  file_path,
  sheet = 1,
  rows = 2:47,
  cols = 13:14
)

saveRDS(csci_table, "shiny-app/data/csci.RDS")

fren_table <- read.xlsx(
  file_path,
  sheet = 1,
  rows = 2:28,
  cols = 16:17
)

saveRDS(fren_table, "shiny-app/data/fren.RDS")

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

apma_ab <- read.xlsx(
  file_path,
  sheet = 2,
  rows = 3:19,
  cols = 10:16,
  colNames = FALSE
)

saveRDS(apma_ab, "shiny-app/data/apma_ab.RDS")

mathcs_scb <- read.xlsx(
  file_path,
  sheet = 2,
  rows = 3:35,
  cols = 22:29,
  colNames = FALSE
)

saveRDS(mathcs_scb, "shiny-app/data/mathcs_scb.RDS")
