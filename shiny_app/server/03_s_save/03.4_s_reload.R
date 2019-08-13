load_trigger <- reactiveValues()

observeEvent(input$saved_inputs_row_to_load, {
  progress <- Progress$new(session, min = 0, max = 2)
  
  row <- as.numeric(input$saved_inputs_row_to_load)
  
  id_to_load <- saved_inputs_table_prep()[row, ] %>% 
    pull(id)
  
  progress$inc(amount = 1, message = "Loading Courses")
  
  semesters_df <- conn %>%
    tbl("semester_courses") %>% 
    collect() %>% 
    filter(id == id_to_load)
  
  for (i in 1:8) {
    courses <- semesters_df %>% 
      filter(semester == paste0("semester", i)) %>% 
      pull(course)
    
    semesters[[paste0("semester", i)]] <- courses
  }
  
  
  progress$inc(amount = 1, message = "Loading Majors")
  
  majors_df <- conn %>% 
    tbl("majors") %>% 
    collect() %>% 
    filter(id == id_to_load)
  
  built_majors(majors_df)
  
  
  progress$close()
})
