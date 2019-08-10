
tables_list <- reactive({
  req(built_majors())
  built_majors <- built_majors()
  
  major_ids <- built_majors$major_id %>% unique()
  names <- built_majors %>% 
    select(major_name, major_id) %>% 
    distinct() %>% 
    pull(major_name)
  
  out <- lapply(major_ids, function(id) {
    major <- built_majors %>% 
      filter(major_id == id)
    
    course_codes <- toupper(major$Code)
    
    in_schedule <- major$Code %in% schedule_list()
    in_schedule <- lapply(in_schedule, function(x) {
      if (isTRUE(x)) {
        as.character(icon("check-circle"))
      } else {
        as.character(icon("circle"))
      }
    })
    
    tibble(
      Code = course_codes,
      Name = major$Name,
      in_schedule = unlist(in_schedule)
    )
  })
  

  
  names(out) <- names
    
  out
})



output$major_tables_ui <- renderUI({
  major_ids <- built_majors()$major_id %>% unique()
  
  lapply(tables_list(), function(x) {
    box(
      datatable(
        x,
        width = "100%",
        rownames = FALSE,
        options = list(
          dom = "t"
        ),
        escape = -3,
        selection = "none"
      )
    )
  })
})
