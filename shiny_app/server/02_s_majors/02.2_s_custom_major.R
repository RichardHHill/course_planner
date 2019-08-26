
custom_table <- reactiveVal(
  tibble(
    Code = rep("", 25),
    Name = rep("", 25)
  )
)

custom_table_trigger <- reactiveVal(0)

output$major_handson_table <- renderRHandsontable({
  custom_table_trigger()
  rhandsontable(
    data = custom_table(),
    stretchH = "last"
  ) %>% 
    hot_cols(colWidths = 80)
})

observeEvent(input$built_majors_row_to_edit, {
  id <- unique(built_majors()$major_id)[as.numeric(input$built_majors_row_to_edit)]
  
  out <- built_majors() %>% 
    filter(major_id == id) %>% 
    select(Code, Name)
  
  out <- rbind(
    out,
    tibble(
      Code = rep("", 25 - nrow(out)),
      Name = rep("", 25 - nrow(out))
    )
  )
  
  custom_table(out)
  custom_table_trigger(custom_table_trigger() + 1)
})

observeEvent(input$select_major_choices, {
  req(major_course_vector())
  
  course_codes <- major_course_vector()
  course_names <- unlist(lapply(course_codes, course_code_to_name))
  
  out <- tibble(
    Code = course_codes,
    Name = course_names
  )
  
  out <- rbind(
    out,
    tibble(
      Code = rep("", 25 - nrow(out)),
      Name = rep("", 25 - nrow(out))
    )
  )
  
  custom_table(out)
  custom_table_trigger(custom_table_trigger() + 1)
})

observeEvent(input$clear_custom_major, {
  custom_table(
    tibble(
      Code = rep("", 25),
      Name = rep("", 25)
    )
  )
  custom_table_trigger(custom_table_trigger() + 1)
})
