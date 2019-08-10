
built_majors <- reactiveVal(
  tibble(
    Code = character(0),
    Name = character(0),
    major_name = character(0),
    id = character(0)
  )
)

observeEvent(input$submit_major, {
  dat <- major_courses_table_prep()
  
  dat$major_name <- input$submit_major_name
  dat$id <- digest::digest(dat)
  
  built_majors(
    rbind(
      built_majors(),
      dat
    )
  )
})

observeEvent(input$submit_custom_major, {
  dat <- hot_to_r(input$major_handson_table) %>% 
    filter(Code != "" | Name != "")
  
  dat$Code <- lapply(dat$Code, function(x) {
    if (nchar(x) > 10) {
      x <- substr(x, 1, 10)
    } else if (nchar(x) < 10) {
      x <- paste0(x, strrep(" ", 10 - nchar(x)))
    }
    x
  })
  
  
  dat$major_name <- input$submit_custom_major_name
  dat$id <- digest::digest(dat)
  
  built_majors(
    rbind(
      built_majors(),
      dat
    )
  )
})

built_majors_table_prep <- reactive({
  out <- built_majors() %>% 
    select(major_name, id) %>% 
    distinct()
  
  if (nrow(out) > 0) {
    rows <- seq_len(nrow(out))
    
    buttons <- paste0(
      '<div class="btn-group width_75" role="group" aria-label="Basic example">
      <button class="btn btn-primary btn-sm edit_btn" data-toggle="tooltip" data-placement="top" title="Edit Major" id = ', rows, ' style="margin: 0"><i class="fa fa-pencil-square-o"></i></button>
      <button class="btn btn-danger btn-sm delete_btn" data-toggle="tooltip" data-placement="top" title="Delete Schedule" id = ', rows, ' style="margin: 0"><i class="fa fa-trash-o"></i></button></div>'
    )
    
    out$button <- buttons
  } else {
    out$button <- character(0)
  }
  
  out %>%
    select(button, major_name)
})

output$built_majors_table <- renderDT({
  out <- built_majors_table_prep()
  
  datatable(
    out,
    rownames = FALSE,
    escape = -1
  )
})
