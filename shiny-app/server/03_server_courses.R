output$courses_table <- renderText({
  txt = "Courses Required for Major 1"
  courses_vector = courses_for_major_1()
  courses = c()
  for (i in seq_along(courses_vector)) {
    courses = c(courses, input[[courses_vector[[i]]]])
  }
  paste(courses, sep = "", collapse = " ")
})