
schedule_list <- reactive({
  all <- c(semester1_to_list(), semester2_to_list(), semester3_to_list(), semester4_to_list(),
    semester5_to_list(), semester6_to_list(), semester7_to_list(), semester8_to_list())
  
  unlist(lapply(all, function (x) gsub("^\\s+|\\s+$", "", x)))
})


major_1_return <- callModule(input_major_module, "1", parent_session = session)
callModule(major_table_module, "1", major_course_vector = major_1_return$courses,
           name = major_1_return$name, shown = major_1_return$shown, schedule_list = schedule_list)

major_2_return <- callModule(input_major_module, "2", parent_session = session)
callModule(major_table_module, "2", major_course_vector = major_2_return$courses,
           name = major_2_return$name, shown = major_2_return$shown, schedule_list = schedule_list)

major_3_return <- callModule(input_major_module, "3", parent_session = session)
callModule(major_table_module, "3", major_course_vector = major_3_return$courses,
           name = major_3_return$name, shown = major_3_return$shown, schedule_list = schedule_list)
