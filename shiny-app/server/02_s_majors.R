
schedule_list <- reactive({
  all <- unlist(reactiveValuesToList(semesters))
  gsub("^\\s+|\\s+$", "", substr(all, 1, 10)) #gsub strips any leading or trailing white space
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
