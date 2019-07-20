
schedule_list <- reactive({
  all <- unlist(reactiveValuesToList(semesters))
  substr(all, 1, 10)
})

# Used to reload major data
major_names <- reactiveValues()


major_1_return <- callModule(input_major_module, "1", id = 1, parent_session = session, major_names = major_names)

callModule(major_table_module, "1", major_course_vector = major_1_return$courses,
           name = major_1_return$name, shown = major_1_return$shown, schedule_list = schedule_list)

major_2_return <- callModule(input_major_module, "2", id = 2, parent_session = session, major_names = major_names)

callModule(major_table_module, "2", major_course_vector = major_2_return$courses,
           name = major_2_return$name, shown = major_2_return$shown, schedule_list = schedule_list)

major_3_return <- callModule(input_major_module, "3", id = 3, parent_session = session, major_names = major_names)

callModule(major_table_module, "3", major_course_vector = major_3_return$courses,
           name = major_3_return$name, shown = major_3_return$shown, schedule_list = schedule_list)

all_majors <- reactive({
  list(major_1_return$data(), major_2_return$data(), major_3_return$data())
})
