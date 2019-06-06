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


courses_table_prep <- reactive({
  selected_courses <- selected_courses()
  course_names <- c()
  
  for (i in seq_along(selected_courses)) {
    course <- selected_courses[[i]]
    department <- substr(course, 1, 4)
    if (department == "MATH"){ #really weird issue
      department_table <- department_list$MATH
    } else {
      department_table <- department_list$ECON
    }
    
    index <- match(course, department_table$course_code)
    course_names <- c(course_names, department_table$course_name[[index]])
  }
  table <- tibble(
    "Course Code" = selected_courses,
    "Course Name" = course_names
  )
})


output$courses_table <- renderDT({
  table <- courses_table_prep()
  datatable(
    table,
    rownames = FALSE
  )
})
