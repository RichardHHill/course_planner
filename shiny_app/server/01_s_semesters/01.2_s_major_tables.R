
tables_list <- reactive({
  req(built_majors())
  built_majors <- built_majors()
  
  major_ids <- unique(built_majors$major_id)
  
  names <- built_majors %>% 
    select(major_name, major_id) %>% 
    distinct %>% 
    pull(major_name)

  
  out <- lapply(major_ids, function(id) {
    major <- built_majors %>% 
      filter(major_id == id)
    
    course_codes <- major$code
    
    in_schedule <- lapply(toupper(course_codes) %in% toupper(schedule_list()), function(x) {
      if (isTRUE(x)) {
        as.character(icon("check-circle"))
      } else {
        as.character(icon("circle"))
      }
    })
    
    tibble(
      code = course_codes,
      name = major$name,
      in_schedule = unlist(in_schedule)
    )
  })
  

  
  names(out) <- names
    
  out
})


output$major_tables_ui <- renderUI({
  tables <- tables_list()
  
  if (length(tables) == 0) {
    box(
      width = 12,
      fluidRow(
        column(
          12,
          align = "center",
          h2("Built Majors Will Show Up Here")
        )
      )
    )
  } else {
    lapply(seq_along(tables), function(x) {
      
      box(
        width = 4,
        title = names(tables)[[x]],
        datatable(
          tables[[x]],
          width = "100%",
          rownames = FALSE,
          colnames = c("Code", "Name", ""),
          options = list(
            dom = "t",
            pageLength = 25,
            scrollY = "400px"
          ),
          escape = -3,
          selection = "none"
        )
      )
    })
  }
})
