

output$major_2_name <- renderText({
  input$pick_major_2
})

output$major_3_name <- renderText({
  input$pick_major_3
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
  all <- c(semester1_to_list(), semester2_to_list(), semester3_to_list(), semester4_to_list(),
    semester5_to_list(), semester6_to_list(), semester7_to_list(), semester8_to_list())
  
  unlist(lapply(all, function (x) gsub("^\\s+|\\s+$", "", x)))
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

major_1_return <- callModule(input_major_module, "1", parent_session = session)

callModule(major_table_module, "1", major_course_vector = major_1_return$courses, name = major_1_return$name, shown = major_1_return$shown, schedule_list = schedule_list)


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
