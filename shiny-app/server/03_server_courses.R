output$courses_table <- renderText({
  txt = "Courses Required for Major 1"
  courses = c()
  for (i in 1:length(courses_for_major_1) + 1) {
    courses = c(courses, input[[courses_for_major_1[[letters[[i]]]]]])
  }
  paste(courses, sep = "", collapse = " ")
})