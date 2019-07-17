

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
  
  out <- tibble(
    major_number = character(0),
    major_name = character(0),
    tag = character(0),
    course = character(0)
  )
  
  for (i in seq_along(majors)) {
    if (length(majors[[i]]) > 1) {
      course_list <- majors[[i]]
      courses <- list()
      
      for (j in seq_along(course_list)) {
        tag <- names(course_list)[[j]]
        tag_courses <- course_list[[j]]
        names(tag_courses) <- rep(tag, length(tag_courses))
        courses <- c(courses, tag_courses)
      }
      
      out <- bind_rows(
        out,
        tibble(
          major_number = paste0("major_", i),
          major_name = majors[[i]]$major,
          tag = names(courses),
          course = unlist(courses)
        )
      )
    }
  }
  
  out
})

observe(print(major_inputs_saved()))

observeEvent(input$save_all_inputs, {
  showModal(
    modalDialog(
      title = "Save Courses and Majors",
      size = "s",
      footer = list(
        actionButton(
          "confirm_save_all",
          "Save All",
          style = "background-color: #46c410; color: #fff",
          icon = icon("plus")
        ),
        modalButton("Cancel")
      ),
      fluidRow(
        column(
          12,
          textInput("passkey", "Passkey")
        )
      ),
      fluidRow(
        column(
          12,
          "This passkey will be used to track all of your saved tables. Make sure it's unique; anyone
           who types it in will be able to see your info!"
        )
      )
    )
  )
})


observeEvent(input$confirm_save_all, {
  removeModal()
  courses_df <- courses_df()
  major_inputs_saved <- major_inputs_saved()
  dat <- courses_df
  
  progress <- Progress$new(session, min = 0, max = 8)
  tryCatch({
    DBI::dbWithTransaction(conn, {
      progress$inc(amount = 1, message = "Saving Inputs", detail = "initializing...")
      
      
    })
    
    session$sendCustomMessage(
      "show_toast",
      message = list(
        type = "success",
        title = "Inputs Successfully Saved!",
        message = NULL
      )
    )
    
    loaded_input_set(hold_loaded_input_set)
    
    progress$close()
  }, error = function(error) {
    
    session$sendCustomMessage(
      "show_toast",
      message = list(
        type = "error",
        title = "Error Saving Inputs",
        message = NULL
      )
    )
    progress$close()
    print(error)
  })
  
})





