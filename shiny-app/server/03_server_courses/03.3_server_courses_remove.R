

observeEvent(input$semester_1_remove, {
  row <- as.numeric(input$semester_1_remove)
  
  semesters$semester1 <- semesters$semester1[-row]
  
  semester1_out <- semester1_out()[-row,]
  semester1_out(semester1_out)
})

observeEvent(input$semester_2_remove, {
  row <- as.numeric(input$semester_2_remove)
  
  semesters$semester2 <- semesters$semester1[-row]
  
  semester2_out <- semester2_out()[-row,]
  semester2_out(semester2_out)
})
