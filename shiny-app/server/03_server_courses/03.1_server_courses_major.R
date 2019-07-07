output$major_1_name <- renderText({
  input$pick_major_1
})

output$major_2_name <- renderText({
  input$pick_major_2
})

output$major_3_name <- renderText({
  input$pick_major_3
})

major_1_course_vector <- reactive({
  req(courses_for_major_1())
  
  courses <- c()
  courses_1 <- courses_for_major_1()
  for (i in seq_along(major_convertor_1())) {
    courses <- c(input[[courses_1[[i]]]], courses)
  }
  courses
})

major_2_course_vector <- reactive({
  req(courses_for_major_2())
  
  courses <- c()
  courses_2 <- courses_for_major_2()
  for (i in seq_along(major_convertor_2())) {
    courses <- c(input[[courses_2[[i]]]], courses)
  }
  courses
})

major_3_course_vector <- reactive({
  req(courses_for_major_3())
  
  courses <- c()
  courses_3 <- courses_for_major_3()
  for (i in seq_along(major_convertor_3())) {
    courses <- c(input[[courses_3[[i]]]], courses)
  }
  courses
})

schedule_list <- reactive({
  c(semester1_to_list(), semester2_to_list(), semester3_to_list(), semester4_to_list(),
    semester5_to_list(), semester6_to_list(), semester7_to_list(), semester8_to_list())
})


major_1_courses_table_prep <- reactive({
  selected_courses <- major_1_course_vector()
  course_names <- unlist(lapply(selected_courses, helpers$course_code_to_name))
  
  course_names[selected_courses == "Flex Course"] <- '<input type="text" value="" size="30" placeholder = "Principles of Economics"/>'
  selected_courses[selected_courses == "Flex Course"] <- '<input type="text" value="" size="10" placeholder = "ECON 0110"/>'
  
  in_schedule <- selected_courses %in% schedule_list()
  in_schedule <- lapply(in_schedule, function(x) {
    if (isTRUE(x)) {
      as.character(icon("check-circle"))
    } else {
      as.character(icon("circle"))
    }
  })
  
  table <- tibble(
    "Course Code" = selected_courses,
    "Course Name" = course_names,
    "Satisfied" = in_schedule
  )
})

major_2_courses_table_prep <- reactive({
  selected_courses <- major_2_course_vector()
  course_names <- vector(mode = "character", length = length(selected_courses))
  in_schedule <- selected_courses %in% schedule_list()
  in_schedule <- lapply(in_schedule, function(x) {
    if (isTRUE(x)) {
      as.character(icon("check-circle"))
    } else {
      as.character(icon("circle"))
    }
  })
  
  course_names <- lapply(selected_courses, helpers$course_code_to_name)
  
  table <- tibble(
    "Course Code" = selected_courses,
    "Course Name" = course_names,
    "Satisfied" = in_schedule
  )
})

major_3_courses_table_prep <- reactive({
  selected_courses <- major_3_course_vector()
  course_names <- vector(mode = "character", length = length(selected_courses))
  in_schedule <- selected_courses %in% schedule_list()
  in_schedule <- lapply(in_schedule, function(x) {
    if (isTRUE(x)) {
      as.character(icon("check-circle"))
    } else {
      as.character(icon("circle"))
    }
  })
  
  course_names <- lapply(selected_courses, helpers$course_code_to_name)
  
  table <- tibble(
    "Course Code" = selected_courses,
    "Course Name" = course_names,
    "Satisfied" = in_schedule
  )
})

output$major_1_courses_table <- renderDT({
  table <- major_1_courses_table_prep()
  datatable(
    table,
    rownames = FALSE,
    escape = FALSE,
    options = list(
      dom = "t",
      pageLength = 25
    )
  )
})

output$major_2_courses_table <- renderDT({
  table <- major_2_courses_table_prep()
  datatable(
    table,
    rownames = FALSE,
    options = list(
      dom = "t",
      pageLength = 25
    )
  )
})

output$major_3_courses_table <- renderDT({
  table <- major_3_courses_table_prep()
  datatable(
    table,
    rownames = FALSE,
    options = list(
      dom = "t",
      pageLength = 25
    )
  )
})
