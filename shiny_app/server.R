server <- function(input, output, session) {
  
  semesters <- reactiveValues()
  
  callModule(select_courses_module, "courses", semesters, majors_return$built_majors)
  majors_return <- callModule(majors_module, "majors", semesters)
  callModule(saved_inputs_module, "saved")
}
