server <- function(input, output, session) {
  source("server/01_s_dashboard.R", local = TRUE)$value
  
  source("server/02_s_majors.R", local = TRUE)$value
  
  source("server/03_s_courses/03.1_s_courses_add.R", local = TRUE)$value
  source("server/03_s_courses/03.2_s_semesters.R", local = TRUE)$value
}
