

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


major_inputs_saved <- reactive({
  majors <- all_majors()
  out <- list()
  
  for (i in seq_along(majors)) {
    out[[paste0("major_", i)]] <- majors[[i]]
  }
  
  out
})

observe(print(major_inputs_saved()))

