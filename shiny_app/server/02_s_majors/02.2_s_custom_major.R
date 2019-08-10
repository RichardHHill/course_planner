
output$major_handson_table <- renderRHandsontable({
  rhandsontable(
    data = tibble(
      Code = rep("", 25),
      Name = rep("", 25)
    ),
    colWidths = c(90, 280)
  )
})

