server <- function(input, output, session) {
  
  semesters <- reactiveValues()
  
  built_majors <- reactiveVal(
    tibble(
      code = character(0),
      name = character(0),
      major_name = character(0),
      major_id = character(0)
    )
  )
  
  callModule(select_courses_module, "courses", semesters, built_majors)
  callModule(majors_module, "majors", semesters, built_majors)
  callModule(saved_inputs_module, "saved", semesters, built_majors, reactive(input$save_all_inputs))
}
