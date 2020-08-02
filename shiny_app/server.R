server <- function(input, output, session) {
  
  semester_names <- reactiveVal(tibble(
    semester_uid = UUIDgenerate(n = 8),
    semester_name = paste("Semester", 1:8)
  ))
  
  semester_courses <- reactiveVal(tibble(
      semester_uid = character(0),
      course_code = character(0),
      course_name = character(0)
  ))
  
  built_majors <- reactiveVal(tibble(
      code = character(0),
      name = character(0),
      major_name = character(0),
      major_id = character(0)
  ))
  
  callModule(select_courses_module, "courses", built_majors, semester_names, semester_courses)
  callModule(majors_module, "majors", built_majors)
  callModule(saved_inputs_module, "saved", built_majors, semester_names, semester_courses)
}
