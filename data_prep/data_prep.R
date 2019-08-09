library(openxlsx)
library(dplyr)

file_path <- "data/provided/Department Courses.xlsx"

###
# Departments
###

department_excel_tribble <- tribble(
  ~name, ~rows,
  "MATH", 2:34,
  "ECON", 2:41,
  "APMA", 2:23,
  "PHYS", 2:28,
  "CSCI", 2:47,
  "FREN", 2:28,
  "HISP", 2:34,
  "CLPS", 2:54,
  "POLS", 2:37,
  "PLCY", 2:17
)

department_list <- lapply(1:nrow(department_excel_tribble), function(row) {
  read.xlsx(
    file_path,
    sheet = 1,
    rows = department_excel_tribble[[row, 2]],
    cols = (3 * row - 2):(3 * row - 1)
  )
})

names(department_list) <- department_excel_tribble$name

for (i in seq_along(department_list)) {
  course_codes <- department_list[[i]]$course_code
  
  for (j in seq_along(course_codes)) {
    if (nchar(course_codes[[j]]) < 10) {
      course_codes[[j]] <- paste0(course_codes[[j]], paste(rep(" ", 10 - nchar(course_codes[[j]])), collapse = ""))
    }
  }
  
  department_list[[i]]$course_code <- course_codes
}

saveRDS(department_list, "shiny-app/data/department_list.RDS")

###
# Majors
###

major_excel_tribble <- tribble(
  ~tag, ~sheet, ~rows, ~cols,
  "apma_ab", "A", 2:19, 1:7,
  "apma_scb", "A", 2:19, 9:18,
  "apma_bio_scb", "A", 2:8, 21:34,
  "apma_cs_scb", "A", 2:11, 37:49,
  "apma_econ_adv_ab", "A", 22:54, 1:12,
  "apma_econ_adv_scb", "A", 22:54, 29:40,
  "apma_econ_mf_ab", "A", 22:54, 15:26,
  "apma_econ_mf_ab", "A", 22:54, 43:54,
  "bds_ab", "B", 1:25, 1:9,
  "econ_ab", "E", 2:32, 1:7,
  "math_ab", "M", 2:21, 1:4,
  "math_scb", "M", 2:21, 9:15,
  "math_cs_scb", "M", 2:35, 22:30,
  "math_econ_ab", "M", 26:56, 1:12,
  "physics_ab", "P", 27:32, 12:19,
  "physics_scb", "P", 27:33, 22:34,
  "psych_ab", "P", 2:22, 1:9,
  "psych_scb", "P", 2:22, 12:22,
  "public_ab", "P", 26:33, 1:7
)

majors_list <- lapply(1:nrow(major_excel_tribble), function(row) {
  read.xlsx(
    file_path,
    sheet = major_excel_tribble[[row, 2]],
    rows = major_excel_tribble[[row, 3]],
    cols = major_excel_tribble[[row, 4]],
    colNames = FALSE
  )
})
names(majors_list) <- major_excel_tribble$tag

for (i in seq_along(majors_list)) {
  courses <- majors_list[[i]][c(-1,-2,-3), ]
  
  for (j in seq_along(courses)) {
    for (k in seq_len(nrow(courses))) {
      course <- courses[k,j]
      if (!is.na(course) & nchar(course) < 10) {
        courses[k,j] <- paste0(courses[k,j], paste(rep(" ", 10 - nchar(course)), collapse = ""))
      }
    }
  }
  
  majors_list[[i]][c(-1,-2,-3), ] <- courses
}

saveRDS(majors_list, "shiny-app/data/majors_list.RDS")

majors_table <- tibble(
  major = names(majors_list),
  display = lapply(names(majors_list), function(x) majors_list[[x]][1,2])
)

saveRDS(majors_table, "shiny-app/data/majors.RDS")
