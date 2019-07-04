server <- function(input, output, session) {
  source("server/01_server_dashboard.R", local = TRUE)$value
  
  source("server/02_server_majors/02.1_major.R", local = TRUE)$value
  source("server/02_server_majors/02.2_major.R", local = TRUE)$value
  source("server/02_server_majors/02.3_major.R", local = TRUE)$value
  
  source("server/03_server_courses/03.1_server_courses_major.R", local = TRUE)$value
  source("server/03_server_courses/03.2_server_courses_add.R", local = TRUE)$value
  source("server/03_server_courses/03.3_server_courses_remove.R", local = TRUE)$value
}
