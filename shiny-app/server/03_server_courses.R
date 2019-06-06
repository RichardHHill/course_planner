output$major_name <- renderText({
  "HI"
})


course_vector <- reactive({
  courses = c()
  for (i in seq_along(major_convertor())) {
    letter <- letters[[i]]
    courses = c(input[[courses_for_major_1[[letter]]]], courses)
  }
  courses
})

selected_courses <- eventReactive(input$majors_to_courses, {
  course_vector()
})


output$courses_table <- renderDT({
  selected_courses <- selected_courses()
  course_names <- c()
  
  for (i in seq_along(selected_courses)) {
    index <- match(selected_courses[[i]], math_courses$course_code)
    course_names <- c(course_names, math_courses$math[[index]])
  }
  table <- tibble(
    "Course Code" = selected_courses,
    "Course Name" = course_names
  )
  datatable(
    table,
    rownames = FALSE
  )
  
})
