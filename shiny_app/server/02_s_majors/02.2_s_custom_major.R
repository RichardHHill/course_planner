
custom_table <- reactiveVal(
  tibble(
    code = rep("", 25),
    name = rep("", 25)
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
    select(code, name)
  
  out <- rbind(
    out,
    tibble(
      code = rep("", 25 - nrow(out)),
      name = rep("", 25 - nrow(out))
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
    code = course_codes,
    name = course_names
  )
  
  out <- rbind(
    out,
    tibble(
      code = rep("", 25 - nrow(out)),
      name = rep("", 25 - nrow(out))
    )
  )
  
  custom_table(out)
  custom_table_trigger(custom_table_trigger() + 1)
})

observeEvent(input$clear_custom_major, {
  custom_table(
    tibble(
      code = rep("", 25),
      name = rep("", 25)
    )
  )
  custom_table_trigger(custom_table_trigger() + 1)
})
