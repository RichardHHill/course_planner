
built_majors <- reactiveVal(
  tibble(
    code = character(0),
    name = character(0),
    major_name = character(0),
    major_id = character(0)
  )
)

observeEvent(input$submit_major, {
  dat <- major_courses_table_prep()
  
  dat$major_name <- input$submit_major_name
  
  id <- digest::digest(dat)
  
  if (!(id %in% built_majors()$major_id)) {
    dat$major_id <- id
    
    built_majors(
      rbind(
        built_majors(),
        dat
      )
    )
  }
})

observeEvent(input$submit_custom_major, {
  dat <- hot_to_r(input$major_handson_table) %>% 
    mutate(
      code = trimws(code),
      name = trimws(name)
    ) %>% 
    filter(code != "" | name != "")
    
  req(nrow(dat) > 0)
  
  dat$major_name <- input$submit_custom_major_name
  id <- digest::digest(dat)

  if (!(id %in% built_majors()$major_id)) {
    dat$major_id <- id
    
    built_majors(
      rbind(
        built_majors(),
        dat
      )
    )
  }
})

built_majors_table_prep <- reactive({
  out <- built_majors() %>% 
    select(major_name, major_id) %>% 
    distinct
  
  if (nrow(out) > 0) {
    rows <- 1:nrow(out)
    
    buttons <- paste0(
      '<div class="btn-group width_75" role="group" aria-label="Basic example">
      <button class="btn btn-primary btn-sm edit_btn" data-toggle="tooltip" data-placement="top" title="Reload Major" id = ', rows, ' style="margin: 0"><i class="fa fa-arrow-left"></i></button>
      <button class="btn btn-danger btn-sm delete_btn" data-toggle="tooltip" data-placement="top" title="Delete Major" id = ', rows, ' style="margin: 0"><i class="fa fa-trash-o"></i></button></div>'
    )
    
    out$button <- buttons
  } else {
    out$button <- character(0)
  }
  
  out
})

output$built_majors_table <- renderDT({
  out <- built_majors_table_prep() %>% 
    select(button, major_name)
  
  datatable(
    out,
    rownames = FALSE,
    escape = -1,
    colnames = c("", "Major Name"),
    selection = "none"
  )
})

observeEvent(input$built_majors_row_to_delete, {
  id <- unique(built_majors()$major_id)[as.numeric(input$built_majors_row_to_delete)]
  
  built_majors(
    built_majors() %>% 
      filter(major_id != id)
  )
})
