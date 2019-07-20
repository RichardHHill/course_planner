library(openxlsx)
library(dplyr)

file_path <- "data/provided/Department Courses.xlsx"

majors_table <- tibble(
  major = c(
    "math_ab",
    "econ_ab",
    "apma_ab",
    "mathcs_scb"
  ),
  display = c(
    "Math AB",
    "Econ AB",
    "Apma AB",
    "Math-CS ScB"
  )
)

saveRDS(majors_table, "shiny-app/data/majors.RDS")

###
# Departments
###

math_courses <- read.xlsx(
  file_path,
  sheet = 1,
  rows = 2:34,
  cols = 1:2
)

econ_courses <- read.xlsx(
  file_path,
  sheet = 1,
  rows = 2:41,
  cols = 4:5
)

apma_courses <- read.xlsx(
  file_path,
  sheet = 1,
  rows = 2:23,
  cols = 7:8
)

phys_courses <- read.xlsx(
  file_path,
  sheet = 1,
  rows = 2:28,
  cols = 10:11
)

csci_courses <- read.xlsx(
  file_path,
  sheet = 1,
  rows = 2:47,
  cols = 13:14
)

fren_courses <- read.xlsx(
  file_path,
  sheet = 1,
  rows = 2:28,
  cols = 16:17
)

hisp_courses <- read.xlsx(
  file_path,
  sheet = 1,
  rows = 2:34,
  cols = 19:20
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

for (i in seq_along(department_list)) {
  course_codes <- department_list[[i]]$course_code
  
  for (j in seq_along(course_codes)) {
    if (nchar(course_codes[[j]]) == 9) {
      course_codes[[j]] <- paste0(course_codes[[j]], " ")
    }
  }
  
  department_list[[i]]$course_code <- course_codes
}

saveRDS(department_list, "shiny-app/data/department_list.RDS")

###
# Majors
###

math_ab <- read.xlsx(
  file_path,
  sheet = 2,
  rows = 2:21,
  cols = 1:4,
  colNames = FALSE
)

econ_ab <- read.xlsx(
  file_path,
  sheet = 2,
  rows = 26:56,
  cols = 1:7,
  colNames = FALSE
)

apma_ab <- read.xlsx(
  file_path,
  sheet = 2,
  rows = 2:19,
  cols = 10:16,
  colNames = FALSE
)

mathcs_scb <- read.xlsx(
  file_path,
  sheet = 2,
  rows = 2:35,
  cols = 22:30,
  colNames = FALSE
)

majors_list <- list(
  "math_ab" = math_ab,
  "econ_ab" = econ_ab,
  "apma_ab" = apma_ab,
  "mathcs_scb" = mathcs_scb
)

for (i in seq_along(majors_list)) {
  courses <- majors_list[[i]][c(-1,-2,-3), ]
  
  for (j in seq_along(courses)) {
    for (k in seq_len(nrow(courses))) {
      course <- courses[k,j]
      if (!is.na(course) & nchar(course == 9)) {
        courses[k,j] <- paste0(courses[k,j], " ")
      }
    }
  }
  
  majors_list[[i]][c(-1,-2,-3), ] <- courses
}

saveRDS(majors_list, "shiny-app/data/majors_list.RDS")

