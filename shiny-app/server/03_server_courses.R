course_vector <- reactive({
  txt = "Courses Required for Major 1"
  courses = c()
  for (i in seq_along(major_convertor())) {
    letter <- letters[[i]]
    courses = c(input[[courses_for_major_1[[letter]]]], courses)
  }
  courses

})

output$courses_table <- renderText({
  paste(course_vector(), sep = "", collapse = " ")
})
