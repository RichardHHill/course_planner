
observeEvent(input$saved_inputs_row_to_load, {
  print("observed")
  row <- as.numeric(input$saved_inputs_row_to_load)
  
  id_to_load <- saved_inputs_table_prep()[row, ] %>% 
    pull(id)
  
  semesters_table <- conn %>%
    tbl("semester_courses") %>% 
    collect() %>% 
    filter(id == id_to_load)
  
  for (i in 1:8) {
    courses <- semesters_table %>% 
      filter(semester == paste0("semester", i)) %>% 
      pull(course)
    print(courses)
    semesters[[paste0("semester", i)]] <- courses
  }
})