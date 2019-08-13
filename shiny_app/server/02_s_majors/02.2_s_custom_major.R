
custom_table <- reactiveVal(
  tibble(
    Code = rep("", 25),
    Name = rep("", 25)
  )
)

output$major_handson_table <- renderRHandsontable({
  rhandsontable(
    data = custom_table(),
    colWidths = c(90, 280)
  )
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
})
