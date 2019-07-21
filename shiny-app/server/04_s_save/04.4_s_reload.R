load_trigger <- reactiveValues()

observeEvent(input$saved_inputs_row_to_load, {
  progress <- Progress$new(session, min = 0, max = 2)
  major_data(NULL)
  
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
  
  major_data(majors_df)

  majors <- majors_df %>% 
    pull(major_number) %>% 
    unique()
  
  #To remove major if there is no replacement
  load_trigger$delete <- Sys.time()
  
  for (i in seq_along(majors)) {
    major_info <- majors_df %>% 
      filter(major_number == majors[[i]])
    
    major_number <- as.character(major_info[1,2])
    
    load_trigger[[major_number]] <- Sys.time()
    
    name <- major_info %>% 
      filter(tag == "major") %>% 
      pull(major_name)
    
    major_names[[major_number]] <- name
  }
  
  progress$close()
})
