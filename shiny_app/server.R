server <- function(input, output, session) {
  
  callModule(select_courses_module, "courses")
  callModule(majors_module, "majors")
  callModule(saved_inputs_module, "saved")
}
