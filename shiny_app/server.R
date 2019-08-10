server <- function(input, output, session) {
  source("server/01_s_dashboard.R", local = TRUE)$value
  
  source("server/02_s_majors/02.1_s_build_major.R", local = TRUE)$value
  source("server/02_s_majors/02.2_s_custom_major.R", local = TRUE)$value
  source("server/02_s_majors/02.3_s_store_majors.R", local = TRUE)$value
  
  source("server/03_s_semesters/03.1_s_semesters.R", local = TRUE)$value
  source("server/03_s_semesters/03.2_s_major_tables.R", local = TRUE)$value
  
  source("server/04_s_save/04.1_s_save_data.R", local = TRUE)$value
  source("server/04_s_save/04.2_s_saved_table.R", local = TRUE)$value
  source("server/04_s_save/04.3_s_delete.R", local = TRUE)$value
  source("server/04_s_save/04.4_s_reload.R", local = TRUE)$value
}
