#turn the display name to the referenced data frame
major_convertor <- reactive({
  index <- match(input$pick_major, majors_table$display)
  majors_list[[majors_table$major[[index]]]]
})
