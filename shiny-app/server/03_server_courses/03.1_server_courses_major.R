output$major_name <- renderText({
  input$pick_major
})

course_vector <- reactive({
  courses = c()
  for (i in seq_along(major_convertor())) {
    letter <- letters[[i]]
    courses = c(input[[courses_for_major_1[[letter]]]], courses)
  }
  courses
})

schedule_list <- reactive({
  c(semester1_to_list(), semester2_to_list(), semester3_to_list(), semester4_to_list(),
    semester5_to_list(), semester6_to_list(), semester7_to_list(), semester8_to_list())
})


courses_table_prep <- reactive({
  selected_courses <- course_vector()
  course_names <- vector(mode = "character", length = length(selected_courses))
  in_schedule <- selected_courses %in% schedule_list()
  
  for (i in seq_along(selected_courses)) {
    course_names[[i]] <- selected_courses[[i]]
  } 
  table <- tibble(
    "Course Code" = selected_courses,
    "Course Name" = course_names,
    "Satisfied" = in_schedule
  )
})


output$courses_table <- renderDT({
  table <- courses_table_prep()
  datatable(
    table,
    rownames = FALSE,
    options = list(
      dom = "t",
      pageLength = 25
    )
  )
})
