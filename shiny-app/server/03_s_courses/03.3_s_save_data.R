

courses_df <- reactive({
  names <- names(reactiveValuesToList(semesters))
  
  out <- tibble(
    semester = character(0),
    course = character(0)
  )
  
  for (i in seq_along(names)) {
    out <- rbind(
      out,
      tibble(
        semester = names[[i]],
        course = semesters[[names[[i]]]]
      )
    )
  }
  
  out
})

observe(print(courses_df()))

