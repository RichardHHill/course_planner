server <- function(input, output, session) {
  source("server/01_server_dashboard.R", local = TRUE)$value
  source("server/02_server_majors.R", local = TRUE)$value
  source("server/03_server_courses.R", local = TRUE)$value
}
