

observeEvent(input$semester_1_remove, {
  row <- as.numeric(input$semester_1_remove)
  semester1_out <- semester1_out()[-row,]
  
  semester1_out(semester1_out)
})
